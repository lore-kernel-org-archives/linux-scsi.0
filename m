Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283D6C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjBBWPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBBWPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:15:17 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470DD13D68
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:15:16 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312Lfqp6024414;
        Thu, 2 Feb 2023 22:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=lylymU1ZqEel6gX7pAGFr41ivoCYyFapY5cKP8mWTsg=;
 b=FlVNuF806Kw8xQZrdQfgFrGnrA+bNKbcEIe0YRUeeuvqAwTOsIYx0ApJHVBfVfIzpzaT
 XBKw8BqddNEZ5Y8rgzfX9YX6cDWr9M2tJ8McBwuaciQthK9YplBUrtwbdZHN3hXXKp1M
 NH6fxiLZUcU4hUAC/rbS0IskmIF7dSWDsoonNp3D00/WvAOv8L7oIDATfwnusQHjRmOE
 +q/NkICrHYs9qzBm9Kgh+aEYYOrm3WK2bQ/RBQCsSbepXsmwtTIhpqAYh1ifxH1DiHYh
 1oagXbtsogmBGKCwmi6l4fyWnFwsPRtCQM62ePEYBqJq9P+mNOQjUP9RGUBU+NAhxcvl Lw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngddycr6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 22:14:37 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312JL4xZ019281;
        Thu, 2 Feb 2023 22:14:36 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ncvur5186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 22:14:36 +0000
Received: from b03ledav001.gho.boulder.ibm.com ([9.17.130.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312MEZMN11862678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 22:14:35 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2396F6E052;
        Thu,  2 Feb 2023 22:16:46 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FBA6E04E;
        Thu,  2 Feb 2023 22:16:42 +0000 (GMT)
Received: from [10.101.7.56] (unknown [9.211.110.248])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 22:16:42 +0000 (GMT)
Message-ID: <3e72df08118eefd2fc738e71c87d65ebce4df330.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Date:   Thu, 02 Feb 2023 17:13:59 -0500
In-Reply-To: <89a59589-a8b6-21cd-9f77-a595216974dc@acm.org>
References: <20230201180637.2102556-1-bvanassche@acm.org>
         <20230201180637.2102556-3-bvanassche@acm.org>
         <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
         <941ac8ba-8814-f3d5-ddc7-712058ea91ef@acm.org>
         <9d784606dfd75feefe653694d920b15e9dfcaff0.camel@linux.ibm.com>
         <89a59589-a8b6-21cd-9f77-a595216974dc@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 79p7z2iwUa40q7DhdXaPwMVonH7NQvlX
X-Proofpoint-GUID: 79p7z2iwUa40q7DhdXaPwMVonH7NQvlX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=538 mlxscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302020196
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-02-02 at 11:00 -0800, Bart Van Assche wrote:
> On 2/2/23 10:46, James Bottomley wrote:
> > Well, that may not be true in all situations.  Semantically FUA is
> > a barrier: it can be implemented such that it destages only the
> > current write plus the cache writes that occurred before the write
> > with the FUA.  It could also be implemented as you suggest above,
> > which simply destages the entire cache, but it doesn't have to be. 
> > One of the reasons for FUA to exist is the potential difference
> > between the two.
> 
> Hi James,
> 
> Although support for the barrier concept has been removed from the
> block layer, would it be possible to tell me in which T10 document I
> can find  more information about the barrier semantics? All I found
> in the latest  SBC-5 draft (revision 4; 2023-01-24) about FUA is the
> following (section 5.40 WRITE (10)):

I have only a vague recollection of manufacturers implementing this
semantic but ...

> "A force unit access (FUA) bit set to one specifies that the device 
> server shall write the logical blocks to:
> a) the non-volatile cache, if any; or
> b) the medium.
> An FUA bit set to zero specifies that the device server shall write
> the logical blocks to:
> a) volatile cache, if any;
> b) non-volatile cache, if any; or
> c) the medium."
> 
> To me the description of FUA in the SBC-3 draft from 11 November 2013
> seems identical to the above text.

So what that says is the FUA write writes to the medium and *doesn't*
flush the volatile cache (so any writeback data stays there).  I assume
this style is for metadata reservations, so we guarantee fs tree
consistency but not necessarily file data consistency.  However, that
makes flushing everything a way bigger hammer than this behaviour.

James

