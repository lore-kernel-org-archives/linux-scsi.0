Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019D7C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 00:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C90B4613DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 00:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhEMAPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 20:15:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230361AbhEMAN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 May 2021 20:13:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14D02j24192221;
        Wed, 12 May 2021 20:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=4Dq8nU7HG2xtMn8ExcBDbZV483UgBmvRMJuLieu7cgk=;
 b=Zn2dyXfj3Sy2JYAeWMPhJP/Y8OkP24X52pYWUYtYsNtghH/MtMQU65YIC+aImvDmpNjr
 YHtO3SeNXrCnc9Ik4WwHH05riujrsSW5fFhbmzdAdo9EEoHdp6wm0KC7vPGeioKhjT6W
 Mpic+OKtxayOy/U0zJg6Ug12Cp6UH69+g0pF+AwFq6Gv3l9JhrJODo78Z5Chh4Z1pKQ9
 lMmphJnU6CLkE/q+BdvlVpC+IiyhHphrkjNAhF5artHHAEBvRDqLKXhFCiTf6A7isDLI
 Q8pffXVtPWtRPJttI2ken8GXAQcqqOAs8LUN7Ld3F87s+nk3EKCvWCXjWnFQAvXjQrNM 8Q== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38gpvnbc75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 20:11:58 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14D04Ser002238;
        Thu, 13 May 2021 00:11:57 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 38dj99scnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 00:11:57 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14D0BuTt61538928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 00:11:56 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77CE678060;
        Thu, 13 May 2021 00:11:56 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB24D7805C;
        Thu, 13 May 2021 00:11:54 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.227.209])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 00:11:54 +0000 (GMT)
Message-ID: <0c2d87fde65e40f34914e7555d3971f7b2c8f28b.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org
Date:   Wed, 12 May 2021 17:11:53 -0700
In-Reply-To: <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
         <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
         <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
         <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
         <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IeiK5Q386sei8vEdg_q64ZAxEtY3MI1v
X-Proofpoint-GUID: IeiK5Q386sei8vEdg_q64ZAxEtY3MI1v
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_13:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120157
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-05-12 at 17:00 -0700, Bart Van Assche wrote:
> On 5/12/21 4:23 PM, James Bottomley wrote:
> > No, we support physical sector sizes up to 4k.  The logical block
> > size internal to the kernel and the block layer is always 512.  I
> > can see the utility in using consistent naming to the block layer,
> > but I can't see that logical block address is confusing ...
> > especially now manufacturers seem all to have aligned on 512 for
> > the logical block size even when it's usually 4k physical.
> 
> Are we talking about the same? Just below the code that I included in
> my previous email there is the following line:
> 
> 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
> 
> where sector_size is the logical block size reported by the READ 
> CAPACITY command and has a value between 512 and 4096.

That was for devices from before the industry standardised, which are
getting harder and harder to find (In fact I'm thinking of making a NFT
out of my last 4k logical/physical disk).  But it didn't alter the fact
that the kernel internal block size is 512.

James


