Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1023C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 17:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiKQR6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 12:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbiKQR55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 12:57:57 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B4B7FF30
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 09:57:50 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHHboff011801;
        Thu, 17 Nov 2022 17:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Upb0wfkUbbu65HdvB0Ifg3//Lu97P0Yd3ONt3Bt6+3g=;
 b=Rj2w0KmKdUTbmjI2Iqh45AFKb/JVuO2ot5K3iCP9obtHSKrEcEXPMnu6pxbWwslkyduL
 F9AvDdF2+IHHBO0ZkZCuQbdzTHctH5h+KTkS63WFaDm2pSV3uhtqf/suGy4yHAQXKfZw
 eZi1Xd2Iv3+ioIZCjv1zoOrwi9rnxSADmpuijkVspMTRYBbm1vW7zIYpsn+OK1ZCjsvn
 hl+WzeWMlQTLEaEeKrctSc4BaPRM0IS/gMGmO8V+gAGyR42EfcFF1IaQiOsq/6Zt/c4W
 kv0BAXS46Rr7/srOPKHpPFRH3cSgHJW/00/5wRHFs/Y4qqdkHpd4O/EyNh/sHaObztyC pQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kws9j8mvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 17:57:36 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AHHo5he028803;
        Thu, 17 Nov 2022 17:57:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3kt2rj5y82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 17:57:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AHHvVac131794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 17:57:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DC2442041;
        Thu, 17 Nov 2022 17:57:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B4F74203F;
        Thu, 17 Nov 2022 17:57:31 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.248])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 17 Nov 2022 17:57:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1ovj8k-0077KU-2K;
        Thu, 17 Nov 2022 18:57:30 +0100
Date:   Thu, 17 Nov 2022 17:57:30 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: alua: Fix alua_rtpg_queue()
Message-ID: <Y3Z2CsAqVXpG1YsX@t480-pf1aa2c2.fritz.box>
References: <20221115224903.2325529-1-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20221115224903.2325529-1-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cF6rHKxLx4WeTj_nq_f4xm51_IIghFyg
X-Proofpoint-ORIG-GUID: cF6rHKxLx4WeTj_nq_f4xm51_IIghFyg
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211170127
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 15, 2022 at 02:49:03PM -0800, Bart Van Assche wrote:
> Modify alua_rtpg_queue() such that it only requests the caller to drop
> the sdev reference if necessary. This patch fixes a recently introduced
> regression.
> 
> Cc: Sachin Sant <sachinp@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Fixes: 0b25e17e9018 ("scsi: alua: Move a scsi_device_put() call out of alua_check_vpd()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 31 ++++++++++++++--------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 

Just FYI, we stumbled over this as well in our CI with zFCP as device
driver and the linux-next cut from yesterday `next-20221116` (it started
a couple of days ago).

When I load the module (and all the SCSI devices get sensed/attached) I
get a seemingly endless stream in Inquiry retries:

[  482.281990] zfcp 0.0.1700: qdio: ZFCP on SC 364 using AI:1 QEBSM:0 PRI:1 TDD:1 SIGA: W
[  482.308284] scsi host0: scsi_eh_0: sleeping
[  482.308355] scsi host0: zfcp
[  482.337627] scsi 0:0:0:16: scsi scan: INQUIRY pass 1 length 36
[  482.337803] scsi 0:0:0:16: scsi scan: INQUIRY successful with code 0x0
[  482.337816] scsi 0:0:0:16: scsi scan: INQUIRY pass 2 length 164
[  482.337987] scsi 0:0:0:16: scsi scan: INQUIRY successful with code 0x0
[  482.337995] scsi 0:0:0:16: Direct-Access     IBM      2107900          2.19 PQ: 0 ANSI: 5
[  482.339397] scsi 0:0:0:16: alua: supports implicit TPGS
[  482.339405] scsi 0:0:0:16: alua: device naa.6005076309ffd430000000000000181a port group 0 rel port 1
[  482.339517] sd 0:0:0:16: sg_alloc: dev=0
[  482.339566] sd 0:0:0:16: Attached scsi generic sg0 type 0
[  482.339907] sd 0:0:0:16: Power-on or device reset occurred
[  482.339923] sd 0:0:0:16: [sda] tag#2560 Done: ADD_TO_MLQUEUE Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[  482.339930] sd 0:0:0:16: [sda] tag#2560 CDB: Test Unit Ready 00 00 00 00 00 00
[  482.339936] sd 0:0:0:16: [sda] tag#2560 Sense Key : Unit Attention [current]
[  482.339942] sd 0:0:0:16: [sda] tag#2560 Add. Sense: Power on, reset, or bus device reset occurred
[  482.388213] sd 0:0:0:16: [sda] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
[  482.388339] sd 0:0:0:16: [sda] Write Protect is off
[  482.388341] sd 0:0:0:16: alua: transition timeout set to 60 seconds
[  482.388342] sd 0:0:0:16: [sda] Mode Sense: ed 00 00 08
[  482.388346] sd 0:0:0:16: alua: port group 00 state A preferred supports tolusnA
[  482.388532] sd 0:0:0:16: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  482.388631] sd 0:0:0:16: [sda] tag#2565 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[  482.388636] sd 0:0:0:16: [sda] tag#2565 CDB: Report supported operation codes a3 0c 01 12 00 00 00 00 00 0a 00 00
[  482.388640] sd 0:0:0:16: [sda] tag#2565 Sense Key : Illegal Request [current]
[  482.388644] sd 0:0:0:16: [sda] tag#2565 Add. Sense: Invalid field in cdb
[  482.388696] scsi 0:0:1:1073758284: scsi scan: INQUIRY pass 1 length 36
[  482.388706] scsi 0:0:1:1073758284: tag#576 Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK cmd_age=0s
[  482.388710] scsi 0:0:1:1073758284: tag#576 CDB: Inquiry 12 80 00 00 24 00
[  482.392545] sd 0:0:0:16: [sda] Attached SCSI disk
[  482.437995] scsi 0:0:1:1073758284: tag#576 Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK cmd_age=0s
[  482.437998] scsi 0:0:1:1073758284: tag#576 CDB: Inquiry 12 80 00 00 24 00
[  482.497958] scsi 0:0:1:1073758284: tag#576 Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK cmd_age=0s
[  482.497965] scsi 0:0:1:1073758284: tag#576 CDB: Inquiry 12 80 00 00 24 00
[  482.537967] scsi 0:0:1:1073758284: tag#576 Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK cmd_age=0s
[  482.537970] scsi 0:0:1:1073758284: tag#576 CDB: Inquiry 12 80 00 00 24 00
[  482.588004] scsi 0:0:1:1073758284: tag#576 Done: NEEDS_RETRY Result: hostbyte=DID_IMM_RETRY driverbyte=DRIVER_OK cmd_age=0s
[  482.588008] scsi 0:0:1:1073758284: tag#576 CDB: Inquiry 12 80 00 00 24 00
...

This continues until the command eventually times out. This seems to
have the nock-on effect that systems booted from SCSI volumes hang after
boot.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
