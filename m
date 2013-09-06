From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND 2/2] Hard disk S3 resume time optimization
Date: Fri, 6 Sep 2013 15:13:32 -0700
Message-ID: <20130906221332.GB7205@linux.intel.com>
References: <20130906004425.GA31998@linux.intel.com>
 <5229CC6C.5010705@cogentembedded.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3IFWN3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Sep 2013 18:13:29 -0400
Content-Disposition: inline
In-Reply-To: <5229CC6C.5010705@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-scsi@vger.kernel.org

I'll fix those, thanks for the feedback. 

On Fri, Sep 06, 2013 at 04:37:00PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 06-09-2013 4:44, Todd E Brandt wrote:
> 
> >Part 2 of the hard disk resume optimization patch, this one applies
> >to the scsi subsystem.
> 
>    Don't give the same name to both patches. In this case, you could
> prefix the patch name with e.g. "sd: ".
> 
> >Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> >Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> >  drivers/scsi/sd.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 81 insertions(+), 1 deletion(-)
> 
> >diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >index 86fcf2c..d4bf784 100644
> >--- a/drivers/scsi/sd.c
> >+++ b/drivers/scsi/sd.c
> [...]
> >@@ -3137,6 +3138,85 @@ done:
> >  	return ret;
> >  }
> >
> >+static void sd_resume_async_end(struct request *rq, int error)
> >+{
> >+	struct scsi_sense_hdr sshdr;
> >+	struct scsi_disk *sdkp = rq->end_io_data;
> >+	char *sense = rq->sense;
> >+
> >+	if (error) {
> >+		sd_printk(KERN_WARNING, sdkp, "START FAILED\n");
> >+		sd_print_result(sdkp, error);
> >+		if (sense && (driver_byte(error) & DRIVER_SENSE)) {
> >+			scsi_normalize_sense(sense,
> >+				SCSI_SENSE_BUFFERSIZE, &sshdr);
> >+			sd_print_sense_hdr(sdkp, &sshdr);
> >+		}
> >+	} else
> >+		sd_printk(KERN_NOTICE, sdkp, "START SUCCESS\n");
> 
>    According to Documentation/CodingStyle, both arms of the *if*
> statement should have {} when one arm has them.
> 
> WBR, Sergei
> 
