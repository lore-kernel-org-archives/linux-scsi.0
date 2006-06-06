From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 0/7] aic94xx: sas code clean-up phase 2
Date: Tue, 06 Jun 2006 16:35:46 -0700
Message-ID: <1149636947.25278.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:28140 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751355AbWFFXgD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:36:03 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Na3N5022337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:36:03 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56Na0kC032784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:36:00 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56Na2Jl016177
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:36:02 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Na2Fq016169
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:36:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is round 2 of the aic94xx supporting sas code clean-up.

Again these patches are being created to address the comments in the
following email:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114624643916659&w=2

The address the following issues:

1) Merge sas header files into libsas.h and sas.h and move them into the
include/scsi dir
2) Use available list_for_each_entry_safe_reverse() function
3) Remove the //depot SCM comments
4) Remove the sas_common.c file
5) Remove the long queue implementation comment-- no longer valid
6) Use bitops for testing, setting and clearing bits
7) Remove various inline functions

There are a few issues that remain, but before I address them I would
like some clarification:

-all the code should be renamed to libsas to make sure this is helpers
 for a host-based sas implementation, including the config option

	Does this mean that you would like to see all the files										under
the drivers/scsi/sas/ dir compressed into one drivers/scsi/libsas.c file
or that the files should just be moved to driver/scsi and start with
libsas_*.c 

-sas_frames*.h need to be changed to avoid on the wite bitfields which
   are completely non-portable.  That'll cause quite a bit of churn all
   over the codebase unfortuantely.  some of those headers should be merged
   with the current scsi_transport_sas.h, e.g. the latter should lose various
   constants that are in sas.h

	why?  There are bit fields in many places under drivers/scsi.  There
shouldn't be any issues between 32 and 64 bit with the u8 definition and
we haven't seen any issues across the two architectures we have tested
here (ppc64 and x86_64).  I just don't see the portability issue in this
case, so please elaborate :).

- drivers/scsi/sas/README needs to be updated to match reality and move
   to Documentation/
	
	What exactly do we want to talk about in this readme file.  Describe
scsi_transport_sas.c?  Explain the driver/scsi/sas/ dir?

- expander_conf.c should go away from the kernel tree.
	
	Is there plan to implement this somewhere else?  If not should it stay
for the moment.

Once these areas have been well discussed and we are all on the same
page I will start on phase 3.  The 7 patches have been attached for
feedback.  Thanks as always for your comments.

Regards,

Alexis


