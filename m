From: Douglas Gilbert <dougg@torque.net>
Subject: [RFC] scsi_normalize_sense()
Date: Fri, 20 Aug 2004 15:43:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41258F6A.6030606@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:36114 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S263962AbUHTFny
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 01:43:54 -0400
Received: from smtp2.uq.edu.au (smtp2.uq.edu.au [130.102.5.53])
	by mailhub2.uq.edu.au (8.12.11/8.12.11) with ESMTP id i7K5hrkh055911
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 15:43:53 +1000 (EST)
Received: from [192.168.48.80] (d-239-61.stlucia.uq.net.au [203.101.239.61])
	by smtp2.uq.edu.au (8.12.10/8.12.10) with ESMTP id i7K5hmO4006468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 15:43:51 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Looking around the linux SCSI subsystem the handling
of data in the sense buffer is haphazard. Most places
ignore "deferred" errors (e.g. medium error reported
later when write caching is on) and will break horribly
if they every see the newer "descriptor" format.

Descriptor format sense data is much cleaner (amongst
other reason are that it doesn't have to carry around 20
years of baggage). See SPC-3 revision 20a section 4.5
at http://www.t10.org for more information.

The sense format a SCSI device will use is controlled
by the D_SENSE bit in the control mode page.

Here is some code which I am proposing to put into
scsi_lib.c to facilitate cleaner handling. I have been
testing it out in sg3_utils-1.08 (beta) for the last
week.  Comments??



/* This is a slightly stretched SCSI sense "descriptor" format header.
    The addition is to allow the 0x70 and 0x71 response codes. The idea
    is to place the salient data of both "fixed" and "descriptor" sense
    format into one structure to ease application processing.
    The original sense buffer should be kept around for those cases
    in which more information is required (e.g. the LBA of a MEDIUM 
ERROR). */
struct scsi_sense_descriptor_hd {
     unsigned char response_code; /* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
     unsigned char sense_key;
     unsigned char asc;
     unsigned char ascq;
     unsigned char byte4;
     unsigned char byte5;
     unsigned char byte6;
     unsigned char additional_length;
};


/* Maps the salient data from a sense buffer which is in either fixed or
    descriptor format into a structure mimicking a descriptor format
    header (i.e. the first 8 bytes).
    If zero response code returns 0. Otherwise returns 1 and if 'sdescp' is
    non-NULL then zero all fields and then set the appropriate fields in
    that structure. sdescp::additional_length is always 0 for response
    codes 0x70 and 0x71 (fixed format). */
int scsi_normalize_sense(const unsigned char * sensep,
                          int sb_len,
                          struct scsi_sense_descriptor_hd * sdescp)
{
     if (sdescp)
         memset(sdescp, 0, sizeof(struct scsi_sense_descriptor_hd));
     if ((NULL == sensep) || (0 == sb_len) || (0x70 != (0x70 & sensep[0])))
         return 0;
     if (sdescp) {
         sdescp->response_code = (0x7f & sensep[0]);
         if (sdescp->response_code >= 0x72) {  /* descriptor format */
             if (sb_len > 1)
                 sdescp->sense_key = (0xf & sensep[1]);
             if (sb_len > 2)
                 sdescp->asc = sensep[2];
             if (sb_len > 3)
                 sdescp->ascq = sensep[3];
             if (sb_len > 7)
                 sdescp->additional_length = sensep[7];
         } else {                              /* fixed format */
             if (sb_len > 2)
                 sdescp->sense_key = (0xf & sensep[2]);
             if (sb_len > 7) {
                 sb_len = (sb_len < (sensep[7] + 8)) ? sb_len :
                                                       (sensep[7] + 8);
                 if (sb_len > 12)
                     sdescp->asc = sensep[12];
                 if (sb_len > 13)
                     sdescp->ascq = sensep[13];
             }
         }
     }
     return 1;
}


Doug Gilbert
