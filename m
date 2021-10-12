Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C55C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 01:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8FB60F38
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 01:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhJLBZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:25:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhJLBZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 21:25:51 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C09UZa015157
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 21:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=UdC/ZSzytgtfvJHWBo6WFRAK7I4ACyq/Nmdp/XiiOaU=;
 b=mIkQVf0sTz14+q32wOKLlt35yXu36oCt35qh4DD9nJOUUCFmFrivb/biVuw1RkKas7vf
 Bqh/DBn9wi1LDC8fBcjtLdCQg2XQhYj1scSAuj8qzXZLiav79ivRP0iQUlycCKNc1N47
 qHyN5iHtniEeT6fy1raeC3CJLC9JpU9db74pX6wVScvxq48npSuflZmKtG1dCa/mm6oL
 W544gM+XCXJgXVfWuyhBozV5SttIpXirLqcOB/YPM7Qcxx16xNfIzEUd326GlEOdRTb6
 PxG9WBGZt6r59ANhACG/S+fneOhek+4bHFw6qfybVS7LZSALEkbUoJmUp1Wovr6/5oxw 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmts1psbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 21:23:50 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C19Z69034863
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 21:23:49 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmts1psap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 21:23:49 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C1DG7j011775;
        Tue, 12 Oct 2021 01:23:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3bk2qas7rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 01:23:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C1Nkq619464846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 01:23:46 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 240667805C;
        Tue, 12 Oct 2021 01:23:46 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7859D78064;
        Tue, 12 Oct 2021 01:23:45 +0000 (GMT)
Received: from jarvis.lan (unknown [9.211.116.119])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 01:23:45 +0000 (GMT)
Message-ID: <3d3ea15a938acca44e1e522ff06129dbcedfc30b.camel@linux.ibm.com>
Subject: 
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     docfate111 <tdwilliamsiv@gmail.com>, linux-scsi@vger.kernel.org
Date:   Mon, 11 Oct 2021 21:23:41 -0400
In-Reply-To: <20211011231530.GA22856@t>
References: <20211011231530.GA22856@t>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e4Ss68doWjMKuCrl0y0UQuaWMwt6tb4j
X-Proofpoint-ORIG-GUID: 97Lb2pIltRYEeqwWMVc96seyTrKl7mfQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_11,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-10-11 at 19:15 -0400, docfate111 wrote:
> linux-scsi@vger.kernel.org,
> linux-kernel@vger.kernel.org,
> martin.petersen@oracle.com
> Bcc: 
> Subject: [PATCH] scsi_lib fix the NULL pointer dereference
> Reply-To: 
> 
> scsi_setup_scsi_cmnd should check for the pointer before
> scsi_command_size dereferences it.

Have you seen this?  As in do you have a trace?  This should be an
impossible condition, so we need to see where it came from.  The patch
as proposed is not right, because if something is setting cmd_len
without setting the cmnd pointer we need the cause fixed rather than
applying a band aid in scsi_setup_scsi_cmnd().

James


