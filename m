From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: scsi_dh_alua: allow I/O in target port
 unavailable and standby states
Date: Tue, 11 Jul 2017 12:32:15 -0300
Message-ID: <224d8cd3-478c-2440-3479-0119885575cf@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <1499726857-7875-2-git-send-email-mauricfo@linux.vnet.ibm.com>
 <b6e97d03-0e1b-df2a-70e2-3247833f3aac@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57959 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932748AbdGKPcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 11:32:32 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6BFT6lZ062658
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 11:32:31 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bn0mst4nq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 11:32:31 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 11 Jul 2017 12:32:29 -0300
In-Reply-To: <b6e97d03-0e1b-df2a-70e2-3247833f3aac@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/11/2017 06:18 AM, Hannes Reinecke wrote:
> NACK.
> 
> The whole_point_  of having device handlers is to_avoid_  I/O errors
> during booting.
> 
> And the ALUA checker is prepared to handle this situation properly.
> The directio checker of course doesn't know about this, but then no-one
> expected the directio checker to work with ALUA.

I lacked that more holistic understanding. Thanks for explaining.

Now, for the sake of logging/debugging...

Any problem with patches 2 and 4?

Also, it seems the Unavailable/Standby states would not be logged
without a recheck from alua_check_sense(), since the only callers
of alua_rtpg_queue() are alua_activate() and alua_check[_sense]()
[the call from alua_check_vpd() is only in the initialization path].

Isn't there a point in scheduling a recheck once those conditions
are found in alua_check_sense() to get them logged? - since valid
path checkers won't go through that function.

(and it occurred to me that the state-change check of patch 3 can
be done there, simpler.)

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
