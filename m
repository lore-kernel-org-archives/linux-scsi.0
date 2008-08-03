From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/2] fusion:  Implement generic interrupt misroute
 handling
Date: Sun, 3 Aug 2008 16:59:40 -0600
Message-ID: <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
References: <1217786709.4179.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49502 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758236AbYHCW7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 18:59:46 -0400
In-Reply-To: <1217786709.4179.27.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@v>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Thanks, I will try this out.   However I thought I saw lost interrupts occurring randomly, meaning it was not necessarily the first config page access.  I'm back in the office on 8/11, I will test it out then and provide feedback.

Eric

________________________________________
From: James Bottomley [James.Bottomley@HansenPartnership.com]
Sent: Sunday, August 03, 2008 12:05 PM
To: linux-scsi; linux-kernel; linux-pci@vger.kernel.org
Cc: Moore, Eric
Subject: [PATCH 2/2] fusion:  Implement generic interrupt misroute handling

This patch uses the new pci_lost_interrupt() callback to note the loss
of an interrupt, and if the reason is MSI, to work around the problem.

I used the manufacturer config page for this, because every fusion type
has that one and its loss means that mpt_config() which is interrupt
driven, failed.

James

---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d6a0074..2d75c58 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -168,7 +168,7 @@ static int  mpt_readScsiDevicePageHeaders(MPT_ADAPTER *ioc, int portnum);
 static void    mpt_read_ioc_pg_1(MPT_ADAPTER *ioc);
 static void    mpt_read_ioc_pg_4(MPT_ADAPTER *ioc);
 static void    mpt_timer_expired(unsigned long data);
-static void    mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
+static int     mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc);
 static int     SendEventNotification(MPT_ADAPTER *ioc, u8 EvSwitch);
 static int     SendEventAck(MPT_ADAPTER *ioc, EventNotificationReply_t *evnp);
 static int     mpt_host_page_access_control(MPT_ADAPTER *ioc, u8 access_control_value, int sleepFlag);
@@ -2052,6 +2052,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
        int      irq_allocated = 0;
        u8      *a;

+ retry:
        printk(MYIOC_s_INFO_FMT "Initiating %s\n", ioc->name,
            reason == MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");

@@ -2268,6 +2269,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
         *      and we try GetLanConfigPages again...
         */
        if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
+               int rc;

                /*
                 * Initalize link list for inactive raid volumes.
@@ -2275,6 +2277,22 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
                mutex_init(&ioc->raid_data.inactive_list_mutex);
                INIT_LIST_HEAD(&ioc->raid_data.inactive_list);

+               /* May fail becuase of IRQ misrouting */
+               rc = mpt_get_manufacturing_pg_0(ioc);
+               if (rc) {
+                       if (pci_lost_interrupt(ioc->pcidev) ==
+                           PCI_LOST_IRQ_DISABLE_MSI) {
+                               free_irq(ioc->pci_irq, ioc);
+                               ioc->msi_enable = 0;
+                               pci_disable_msi(ioc->pcidev);
+                               goto retry;
+                       }
+                       printk(MYIOC_s_ERR_FMT "Cannot recover IRQ routing\n",
+                              ioc->name);
+                       return -1;
+               }
+
+
                if (ioc->bus_type == SAS) {

                        /* clear persistency table */
@@ -2326,7 +2344,6 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
                }

                GetIoUnitPage2(ioc);
-               mpt_get_manufacturing_pg_0(ioc);
        }

        /*
@@ -5697,13 +5714,14 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
        return;
 }

-static void
+static int
 mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 {
        CONFIGPARMS             cfg;
        ConfigPageHeader_t      hdr;
        dma_addr_t              buf_dma;
        ManufacturingPage0_t    *pbuf = NULL;
+       int                     ret;

        memset(&cfg, 0 , sizeof(CONFIGPARMS));
        memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
@@ -5714,20 +5732,23 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
        cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
        cfg.timeout = 10;

-       if (mpt_config(ioc, &cfg) != 0)
+       ret = mpt_config(ioc, &cfg);
+       if (ret != 0)
                goto out;

        if (!cfg.cfghdr.hdr->PageLength)
                goto out;

        cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
+       ret = -ENOMEM;
        pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
        if (!pbuf)
                goto out;

        cfg.physAddr = buf_dma;

-       if (mpt_config(ioc, &cfg) != 0)
+       ret = mpt_config(ioc, &cfg);
+       if (ret != 0)
                goto out;

        memcpy(ioc->board_name, pbuf->BoardName, sizeof(ioc->board_name));
@@ -5738,6 +5759,7 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)

        if (pbuf)
                pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+       return ret;
 }

 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/


