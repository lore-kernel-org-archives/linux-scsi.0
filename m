Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FD1C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EAD320857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 14:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgEAOx7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 10:53:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728737AbgEAOx7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 10:53:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041EWMTO023972;
        Fri, 1 May 2020 10:53:44 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r82muqf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:53:44 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041EqEmf026392;
        Fri, 1 May 2020 14:53:43 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 30mcu7kfxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 14:53:43 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041Ergpe59310418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 14:53:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAD627805E;
        Fri,  1 May 2020 14:53:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12D2C7805C;
        Fri,  1 May 2020 14:53:39 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.187.215])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 14:53:39 +0000 (GMT)
Message-ID: <1588344818.3428.18.camel@linux.ibm.com>
Subject: Re: [PATCH 13/15] scsi: sas: avoid gcc-10 zero-length-bounds warning
From:   James Bottomley <jejb@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>, John Garry <john.garry@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date:   Fri, 01 May 2020 07:53:38 -0700
In-Reply-To: <CAK8P3a1=5dmgB+k9B_jk2qBhBPnMSFMWrByP4jRvyvaJwBo94A@mail.gmail.com>
References: <20200430213101.135134-1-arnd@arndb.de>
         <20200430213101.135134-14-arnd@arndb.de>
         <b5e6ef12-c2ac-d0ce-b7a1-a58d4c8de300@huawei.com>
         <CAK8P3a1=5dmgB+k9B_jk2qBhBPnMSFMWrByP4jRvyvaJwBo94A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_07:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 clxscore=1011 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010112
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-05-01 at 09:54 +0200, Arnd Bergmann wrote:
> On Fri, May 1, 2020 at 9:48 AM John Garry <john.garry@huawei.com>
> wrote:
> > On 30/04/2020 22:30, Arnd Bergmann wrote:
> > > This should really be a flexible-array member, but the structure
> > > already has such a member, swapping it out with sense_data[]
> > > would cause many more warnings elsewhere.
> > > 
> > 
> > 
> > Hi Arnd,
> > 
> > If we really prefer flexible-array members over zero-length array
> > members, then could we have a union of flexible-array members? I'm
> > not sure if that's a good idea TBH (or even permitted), as these
> > structures are defined by the SAS spec and good practice to keep as
> > consistent as possible, but just wondering.
> 
> gcc does not allow flexible-array members inside of a union, or more
> than one flexible-array member at the end of a structure.
> 
> I found one hack that would work, but I think it's too ugly and
> likely not well-defined either:
> 
> struct ssp_response_iu {
> ...
>         struct {
>                 u8      dummy[0]; /* a struct must have at least one
> non-flexible member */

If gcc is now warning about zero length members, why isn't it warning
about this one ... are unions temporarily excluded?

>                 u8      resp_data[]; /* allowed here because it's at
> the one of a struct */
>         };
>         u8     sense_data[];
> } __attribute__ ((packed));

Let's go back to what the standard says:  we want the data beyond the
ssp_response_iu to be addressable either as sense_data if it's an error
return or resp_data if it's a real response.  What about trying to use
an alias attribute inside the structure ... will that work on gcc-10?

James

