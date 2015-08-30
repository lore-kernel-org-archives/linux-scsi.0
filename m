From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight
 mpt2sas
Date: Sun, 30 Aug 2015 00:22:06 -0700
Message-ID: <1440919326.2104.111.camel@haakon3.risingtidesystems.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	 <20150826235434.GA8843@mail.thefacebook.com>
	 <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
	 <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
	 <1440686414.2196.107.camel@HansenPartnership.com>
	 <1440702941.24282.2.camel@haakon3.risingtidesystems.com>
	 <1440793538.2202.55.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440793538.2202.55.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-08-28 at 13:25 -0700, James Bottomley wrote:
> On Thu, 2015-08-27 at 12:15 -0700, Nicholas A. Bellinger wrote:
> > On Thu, 2015-08-27 at 07:40 -0700, James Bottomley wrote:
> > > On Thu, 2015-08-27 at 10:37 +0530, Sreekanth Reddy wrote:
> > > > HI Nicholas & Calvin,
> > > > 
> > > > Thanks for the patchset. Sure We will review and we do some unit
> > > > testing on this patch series. Currently my bandwidth is occupied with
> > > > some internal activity, so by end of next week I will acknowledge this
> > > > series if all the thing are fine with this patch series.
> > > 
> > > Calvin responded to your review feedback and that series has been
> > > outstanding for a while, so I'm not going to drop it from the misc tree.
> > > However, I will reorder to make it ready for the second push. You have
> > > until Friday week to find a problem with it.
> > > 
> > 
> > James, as mentioned this series is functionally identical to Calvin's
> > mpt2sas series.
> > 
> > Please consider merging it to scsi.git/for-next, so both series are
> > together and in-sync.
> 
> Unfortunately, the driver isn't, thanks to drift between v2 and v3 of
> the mpt_sas code bases.  This patch is also dangerous: the early
> versions left unremoved objects lying around, so  getting some stress
> testing from avago is very useful.  At this point in the cycle, the risk
> vs reward of doing a blind upport to mpt3_sas is just too great and the
> time for review and stress testing too limited within the merge window.

To clarify, this series is Calvin's latest -v4 mpt2sas changes that
you've already merged into for-next, and that have been applied (by
hand) to v4.2-rc1 mpt3sas code.

If you look closer, this series is an obvious bug-fix for a class of
long-standing bugs within mpt*sas, and I don't see how keeping the
broken list_head dereferences in one LLD, but not the other makes any
sense at this point. 

Unfortunately, the mpt3sas patches you've merged this week add yet more
bogus mpt3sas_scsih_sas_device_find_by_sas_address() usage.  Really,
adding more broken code to mpt3sas can't possibly be better than just
merging this bug-fix series.

Here's are two cases that required fixing to apply this series atop
latest scsi.git/for-next:

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 85ff0dd..897153b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2866,7 +2874,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
        struct scsi_device *sdev;
        struct _sas_device *sas_device;
 
-       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+       sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
        if (!sas_device)
                return;
 
@@ -2882,6 +2890,8 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
                        continue;
                _scsih_internal_device_block(sdev, sas_device_priv_data);
        }
+
+       sas_device_put(sas_device);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 18f1de5..6074b11 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -734,7 +734,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
        rphy->identify = mpt3sas_port->remote_identify;
 
        if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
-               sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+               sas_device = __mpt3sas_get_sdev_by_addr(ioc,
                                    mpt3sas_port->remote_identify.sas_address);
                if (!sas_device) {
                        dfailprintk(ioc, printk(MPT3SAS_FMT
@@ -750,8 +750,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
                    ioc->name, __FILE__, __LINE__, __func__);
        }
 
-       if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE)
+       if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
                sas_device->pend_sas_rphy_add = 0;
+               sas_device_put(sas_device);
+       }
 
        if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
                dev_printk(KERN_INFO, &rphy->dev,

Also, I'm currently using the -v1 series on v3.14.47 atop 40 nodes with
12 HDDs per HBA. (480 total), and the number of HBAs using this series
will double over the next week.  The specific hardware setup is:

  LSI Logic / Symbios Logic SAS3008 PCI-Express Fusion-MPT SAS-3 (rev 02)

Thus far, it has resolved the original OOPsen bug that would appear
occasionally during boot with a failing HDD.  So far, no other new
regressions have appeared.

That said, I'll be posting the updated -v2 atop current scsi/for-next
shortly, and will push to target-pending/for-next-merge for now to be
picked up for 0-day + linux-next.

Please consider picking it up for v4.3-rc1, otherwise I'll plan to push
to Linus with Sreekanth's ACK, barring any new regressions or other
specific -v2 code comments.

--nab
