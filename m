From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: RE: [SCSI] qla2xxx: Fix a memory leak in an error path of
 qla2x00_process_els()
Date: Mon, 14 Aug 2017 10:38:17 -0500
Message-ID: <68234383-92ad-c5f0-9d85-3b5319ba7bbe@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37851 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbdHNPiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 11:38:19 -0400
Received: by mail-it0-f42.google.com with SMTP id 76so19841516ith.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2017 08:38:18 -0700 (PDT)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart -

I've been porting patches from mainline into a copy of QLogic's target driver tree
and ran across an anomaly in this changeset of yours from 2013
(8c0eb596baa51f2b43949c698c644727ef17805c).


The commit log says:

     ... Make it easy for Coverity (and for humans) to recognize that there is no
     fcport leak in the error path by changing the

       bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN

     test into

       bsg_job->request->msgcode != FC_BSG_RPT_ELS.


But the change actually made was this:

@@ -399,7 +399,7 @@ done_unmap_sg:
  	goto done_free_fcport;
  
  done_free_fcport:
-	if (bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN)
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS)
  		kfree(fcport);
  done:
  	return rval;


Shouldn't the "== FC_BSG_RPT_ELS" be "!= FC_BSG_RPT_ELS"?

Regards,
------------------------------------------------------------------------
  Steven J. Magnani               "I claim this network for MARS!
  www.digidescorp.com              Earthling, return my space modulator!"

  #include <standard.disclaimer>
