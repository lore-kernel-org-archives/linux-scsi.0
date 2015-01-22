From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: sc_data_direction and bidi commands
Date: Thu, 22 Jan 2015 12:51:19 +0100
Message-ID: <54C0E437.5090102@sandisk.com>
References: <54BFD163.4020802@sandisk.com>
	 <1421920974.7061.55.camel@haakon3.risingtidesystems.com>
	 <54C0CD85.4000700@sandisk.com>
 <1421923168.7061.66.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:16774
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbbAVLv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2015 06:51:26 -0500
In-Reply-To: <1421923168.7061.66.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/22/15 11:39, Nicholas A. Bellinger wrote:
> Well, according to DMA-API.txt it's classified as:
> 
>    DMA_BIDIRECTIONAL       direction isn't known
> 
> and is unrelated to any actual SCSI bidi commands containing both WRITE
> and READ payload buffers.

I think I figured out why several SCSI LLDs are comparing
sc_data_direction with DMA_BIDIRECTIONAL. In code that has been removed
eight years ago I found the following construct (see also
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit?id=21b2f0c803adaf00fce1b606c50b49ae8b106773):

               if (inlen == 0) {
                       data_direction = DMA_FROM_DEVICE;
               } else if (outlen == 0 ) {
                       data_direction = DMA_TO_DEVICE;
               } else {
                       /*
                        * Can this ever happen?
                        */
                       data_direction = DMA_BIDIRECTIONAL;
               }

Here is some more removed code from the same timeframe
(https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit?id=beb40487508290f5d6565598c60a3f44261beef2):

struct scsi_request *scsi_allocate_request(struct scsi_device *sdev,
                                          gfp_t gfp_mask)
{
       const int offset = ALIGN(sizeof(struct scsi_request), 4);
       const int size = offset + sizeof(struct request);
       struct scsi_request *sreq;

       sreq = kzalloc(size, gfp_mask);
       if (likely(sreq != NULL)) {
               sreq->sr_request = (struct request *)(((char *)sreq)
                                  + offset);
               sreq->sr_device = sdev;
               sreq->sr_host = sdev->host;
               sreq->sr_magic = SCSI_REQ_MAGIC;
               sreq->sr_data_direction = DMA_BIDIRECTIONAL;
       }

       return sreq;
}

Bart.
