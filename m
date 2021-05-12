Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2D5C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE18613E3
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbhELWnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1442673AbhELWMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 May 2021 18:12:22 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CM2lp0012678;
        Wed, 12 May 2021 18:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=fz6xKqnY98mXrxPty8UvqdvKtr0PsEjUG3s7tD7EdQ4=;
 b=ecLmkNUhOM2+jb4NS9+2L5sVQ+LsHxLuLqjInhrUEObNv+uGE2+5Pyazzv4rFa0TOBXa
 nT7oaIeVU4UD0AedHHa03EkGGZBfaf7MOfq6WPrifS8wUvXRDeRUCaHZjmd49gFLmbnx
 iB80i6VaEfyNmsLnfMYwp4GVadt+7HbrM0tadzLqk8sMB+yJTMLtCWzeOqDYNdr8QGBO
 hozDFZeK+TQb3W5eiZuiF5M8Lm6yuKTfpTBQcePv0qdmuEwYncO3/TKISBDs0rA8fxxx
 aIpjbjUAXlAXlGighcCodgOY8BU0bvS0o6bwsau5DpTDqgzHLW9Iazza4HU6tb4xGBb5 9g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38gq6f0jmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 18:10:54 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14CLwKRm000773;
        Wed, 12 May 2021 22:10:54 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 38dj9a0nj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 22:10:53 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14CMAqbg21430776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 22:10:52 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE0E37807C;
        Wed, 12 May 2021 22:10:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC127805C;
        Wed, 12 May 2021 22:10:51 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.227.209])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 12 May 2021 22:10:50 +0000 (GMT)
Message-ID: <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
From:   James Bottomley <jejb@linux.vnet.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org
Date:   Wed, 12 May 2021 15:10:49 -0700
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w_CijMVx-1ojHCSI4ou9t7Zz6MHFJZj4
X-Proofpoint-GUID: w_CijMVx-1ojHCSI4ou9t7Zz6MHFJZj4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_13:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 mlxlogscore=639 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120142
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-05-12 at 13:08 -0700, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series renames scsi_get_lba() into scsi_get_pos(). The
> name of scsi_get_lba() is confusing since it does not return an LBA
> but instead the start offset divided by 512.

OK, I'll bite: given the logical block size for all drives is 512 why
is logical block address not the start offset in bytes divided by 512?

James


