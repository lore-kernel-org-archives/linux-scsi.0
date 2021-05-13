Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86815C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD5F6142E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 05:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhEMFnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 01:43:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62890 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhEMFnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 May 2021 01:43:45 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14D5YRIT180842;
        Thu, 13 May 2021 01:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=dYJ4dXD7+POi3t+VvYZavix0lfLsjBa4p7VEQcNI5Qs=;
 b=Iwj0fl5LdlkF+FfGHj9clkXBzKeR7D6c9aHfDxUdz2lhK/KcI3CFYPPKyf1I/G68y9fj
 p0iOz03HKMDWSdCNWirCMTcjLAmlxzdTvAcrEghDegXJD66a1EqIJSZ38D3DyXvfD6hd
 nXP9OrhbKM2D3vc9WYcrPVLngnQFJJ33F276J7Lrv9Cgi7TqSh+xJX3jbnBtV3x44IbT
 GQ4jotoVQw6I0T715jCC0wFZ8H3yGPPGibxI6h7bvBgpEY6IV4FWeQUTXzc0fgM3anY8
 3DJQAm4NOkcx7TPHVYdWBQi1cQ62beTt920EmC0ohuekqfBIE6u2JvtT6hQElSyWQim8 qg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38gwymr8cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 01:42:22 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14D5awMt017547;
        Thu, 13 May 2021 05:42:22 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 38dj9a3d6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 05:42:22 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14D5gKCU61211166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 05:42:21 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8E887805C;
        Thu, 13 May 2021 05:42:20 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1099D78060;
        Thu, 13 May 2021 05:42:18 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.208.94])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 05:42:18 +0000 (GMT)
Message-ID: <e7f37452622d4203f7246747b858f94a5e53b664.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Wed, 12 May 2021 22:42:17 -0700
In-Reply-To: <DM6PR04MB708186DD35EB12B26BC9CE60E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512200849.9002-1-bvanassche@acm.org>
         <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
         <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
         <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
         <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
         <0c2d87fde65e40f34914e7555d3971f7b2c8f28b.camel@linux.ibm.com>
         <DM6PR04MB708186DD35EB12B26BC9CE60E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BcQejXxKJm6_2cTkx8R1cJD3UUelnVRN
X-Proofpoint-ORIG-GUID: BcQejXxKJm6_2cTkx8R1cJD3UUelnVRN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_03:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-05-13 at 02:18 +0000, Damien Le Moal wrote:
> On 2021/05/13 9:14, James Bottomley wrote:
> > On Wed, 2021-05-12 at 17:00 -0700, Bart Van Assche wrote:
> > > On 5/12/21 4:23 PM, James Bottomley wrote:
> > > > No, we support physical sector sizes up to 4k.  The logical
> > > > block size internal to the kernel and the block layer is always
> > > > 512.  I can see the utility in using consistent naming to the
> > > > block layer, but I can't see that logical block address is
> > > > confusing ... especially now manufacturers seem all to have
> > > > aligned on 512 for the logical block size even when it's
> > > > usually 4k physical.
> > > 
> > > Are we talking about the same? Just below the code that I
> > > included in my previous email there is the following line:
> > > 
> > > 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
> > > 
> > > where sector_size is the logical block size reported by the READ 
> > > CAPACITY command and has a value between 512 and 4096.
> > 
> > That was for devices from before the industry standardised, which
> > are getting harder and harder to find (In fact I'm thinking of
> > making a NFT out of my last 4k logical/physical disk).  But it
> > didn't alter the fact that the kernel internal block size is 512.
> 
> struct bio and struct request use 512B sector_t unit addressing. So
> does the entire block layer, file systems device mapper etc. SAll
> users of block devices use this unit. Yes, that is fixed to 512B,
> regardless of the characteristics of the target device. But to avoid
> confusion, we never refer to this as the "logical block size" or
> "block size". We use the term "sector" and reserve the term "block"
> for the device layer.

Doing a git grep -iw lba in block will refute this.  I think the
partition code still uses it because it's what most standards still
say.

> The logical block size (the unit used for command addressing) may or
> may not be 512B (it may or may not be equal to the block layer sector
> size). These days, most HDDs are 512e, that is, 512B logical block
> size and 4K physical block size. Lots of SSDs are still 512/512.
> 4K/4K HDDs and SSDs are gaining ground and spreading.
> 
> I agree with Bart's cleanup patches. They correct a non-standard use
> of the term LBA to refer to a value using the block layer sector
> unit.  Bart suggested scsi_get_pos() as the new function name to
> solve the confusion. I think that using scsi_get_sector() as a name
> would be even clearer about the unit of the values being handled.

To be clear, I think that using _pos everywhere is at least consistent,
even if I think it's not very logical, so I'm happy on that basis.  I'm
just not happy with the attempt to characterise LBA as confusing since
it's been the terminology forever and still permeates at least the
partition code in block and predates the logical/physical addition to
the SCSI standards.  Just say that for consistency we'd like to use
_pos everywhere ... or if you want to use _sector, that's OK, but then
update block as well.

Historically, logical meant our internal sector size, i.e. 512 and
physical meant whatever the device returned until the SCSI committee
suddenly wanted their own versions of logical and physical to cover for
the 4k block size fiasco.

James



