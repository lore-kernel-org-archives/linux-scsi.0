Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1128C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 23:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93ED6613C0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 23:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347098AbhELXdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236480AbhELXYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 May 2021 19:24:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CNIWtc030569;
        Wed, 12 May 2021 19:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=zwbYixYUXT8/7XAkgJ3HWr5gpF5ALyKjA88iCuFqMwc=;
 b=A/y+WSkcBMI1pyQWac0d6XAsstQFw614JKNj8eM4al5x5mwwmiitkMOOn19qyNg4dtD0
 HlrJLx931iIhk4DccFu8tieXRY9GhA+E5crvzhgcaeBPFw4wUUTOHB1pehiB6UhXpfrp
 Bx6thxoPkPmSByZFOSBMjW99zrn8qm1gRBS04Voz4hL4QpgHLFqbTvZw7HgE87/oFkme
 RF+pRVIGh32N07tJ7nTpq/XbxYATVuR+PPVj5eUlCQKkGNFhP/U8eXtcUyl0phUggKca
 YcAAcazIEyRYCxcN/qUh36EMIE4pHace99eeRStMd0vi/wnpThAdDG4ddQkmiCfrNTGa hA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38grk102pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 19:23:06 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CNMFEP021504;
        Wed, 12 May 2021 23:23:05 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 38dj9a1383-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 23:23:05 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CNN4TV10092872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 23:23:04 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE5978060;
        Wed, 12 May 2021 23:23:04 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F657805F;
        Wed, 12 May 2021 23:23:02 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.227.209])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 12 May 2021 23:23:02 +0000 (GMT)
Message-ID: <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
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
Date:   Wed, 12 May 2021 16:23:01 -0700
In-Reply-To: <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
         <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
         <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gfFJYPFQeJwhQiBJ2riGl7kaOV-z5pSR
X-Proofpoint-GUID: gfFJYPFQeJwhQiBJ2riGl7kaOV-z5pSR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_13:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 clxscore=1011 phishscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=657 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120150
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-05-12 at 15:20 -0700, Bart Van Assche wrote:
> On 5/12/21 3:10 PM, James Bottomley wrote:
> > On Wed, 2021-05-12 at 13:08 -0700, Bart Van Assche wrote:
> > > This patch series renames scsi_get_lba() into scsi_get_pos(). The
> > > name of scsi_get_lba() is confusing since it does not return an
> > > LBA but instead the start offset divided by 512.
> > 
> > OK, I'll bite: given the logical block size for all drives is 512
> > why is logical block address not the start offset in bytes divided
> > by 512?
> 
> My understanding is that LBA = logical block address = (start offset
> in  bytes) / (logical block size) and also that the Linux kernel
> supports  logical block sizes between 512 bytes and 4 KiB.

No, we support physical sector sizes up to 4k.  The logical block size
internal to the kernel and the block layer is always 512.  I can see
the utility in using consistent naming to the block layer, but I can't
see that logical block address is confusing ... especially now
manufacturers seem all to have aligned on 512 for the logical block
size even when it's usually 4k physical.

James


