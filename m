From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] scsi_normalize_sense()
Date: Tue, 24 Aug 2004 12:04:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412B66F7.4020108@adaptec.com>
References: <41258F6A.6030606@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:23007 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268080AbUHXQEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 12:04:10 -0400
In-Reply-To: <41258F6A.6030606@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Looking around the linux SCSI subsystem the handling
> of data in the sense buffer is haphazard. Most places
> ignore "deferred" errors (e.g. medium error reported
> later when write caching is on) and will break horribly
> if they every see the newer "descriptor" format.
> 
> Descriptor format sense data is much cleaner (amongst
> other reason are that it doesn't have to carry around 20
> years of baggage). See SPC-3 revision 20a section 4.5
> at http://www.t10.org for more information.
> 
> The sense format a SCSI device will use is controlled
> by the D_SENSE bit in the control mode page.
> 
> Here is some code which I am proposing to put into
> scsi_lib.c to facilitate cleaner handling. I have been
> testing it out in sg3_utils-1.08 (beta) for the last
> week.  Comments??
> 
> 
> 
> /* This is a slightly stretched SCSI sense "descriptor" format header.
>     The addition is to allow the 0x70 and 0x71 response codes. The idea
>     is to place the salient data of both "fixed" and "descriptor" sense
>     format into one structure to ease application processing.
>     The original sense buffer should be kept around for those cases
>     in which more information is required (e.g. the LBA of a MEDIUM
> ERROR). */
> struct scsi_sense_descriptor_hd {

Since this would represend neither descriptor nor fixed
sense format, why not call it just "scsi_sense_hd"?

		Luben



>      unsigned char response_code; /* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
>      unsigned char sense_key;
>      unsigned char asc;
>      unsigned char ascq;
>      unsigned char byte4;
>      unsigned char byte5;
>      unsigned char byte6;
>      unsigned char additional_length;
> };
> 
> 
> /* Maps the salient data from a sense buffer which is in either fixed or
>     descriptor format into a structure mimicking a descriptor format
>     header (i.e. the first 8 bytes).
>     If zero response code returns 0. Otherwise returns 1 and if 'sdescp' is
>     non-NULL then zero all fields and then set the appropriate fields in
>     that structure. sdescp::additional_length is always 0 for response
>     codes 0x70 and 0x71 (fixed format). */
> int scsi_normalize_sense(const unsigned char * sensep,
>                           int sb_len,
>                           struct scsi_sense_descriptor_hd * sdescp)
> {
>      if (sdescp)
>          memset(sdescp, 0, sizeof(struct scsi_sense_descriptor_hd));
>      if ((NULL == sensep) || (0 == sb_len) || (0x70 != (0x70 & sensep[0])))
>          return 0;
>      if (sdescp) {
>          sdescp->response_code = (0x7f & sensep[0]);
>          if (sdescp->response_code >= 0x72) {  /* descriptor format */
>              if (sb_len > 1)
>                  sdescp->sense_key = (0xf & sensep[1]);
>              if (sb_len > 2)
>                  sdescp->asc = sensep[2];
>              if (sb_len > 3)
>                  sdescp->ascq = sensep[3];
>              if (sb_len > 7)
>                  sdescp->additional_length = sensep[7];
>          } else {                              /* fixed format */
>              if (sb_len > 2)
>                  sdescp->sense_key = (0xf & sensep[2]);
>              if (sb_len > 7) {
>                  sb_len = (sb_len < (sensep[7] + 8)) ? sb_len :
>                                                        (sensep[7] + 8);
>                  if (sb_len > 12)
>                      sdescp->asc = sensep[12];
>                  if (sb_len > 13)
>                      sdescp->ascq = sensep[13];
>              }
>          }
>      }
>      return 1;
> }
> 
> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

