From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 04:01:11 -0700
Message-ID: <20140716110111.GA7382@infradead.org>
References: <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 13, 2014 at 08:58:34AM -0400, Martin K. Petersen wrote:
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> KY> Windows hosts do support UNMAP and set the field in the
> KY> EVPD. However, since the host advertises SPC-2 compliance, Linux
> KY> does not even query the VPD page.
>  
> >> If we want to enable UNMAP in this case I'd prefer a blacklist entry
> >> than trying UNMAP despite the device not advertising it.
> 
> I agree with that. We could do something like the patch below.
> 
> However, I do think it's a good idea that you guys are looking into
> reporting SPC-3.

KY mentioned that they have a prototype for that now.

Btw, I looked over sd.c a bit more, and I think I understand why they
get the WRITE SAME commands now:

read_capacity_16 calls sd_config_discard(sdkp, SD_LBP_WS16) if the LPBME
bit is set.  At least older SBC drafts left it wide open if a target
supports WRITE SAME with UNMAP or UNMAP in this case.  So I think we'd
still want a patch to use UNMAP instead of WRITE SAME for this case,
which should also fix hyperv.  Below is the quick hack version of that
that just checks the host no_write_same flag, as the one on the device
isn't set yet - I guess we need to refactor some of that logic.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 87566b5..4480fdf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2035,7 +2035,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
 
-		sd_config_discard(sdkp, SD_LBP_WS16);
+		if (sdp->host->no_write_same)
+			sd_config_discard(sdkp, SD_LBP_UNMAP);
+		else
+			sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
