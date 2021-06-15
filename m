Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161D7C48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF6366144F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFOJeL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 05:34:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230502AbhFOJeJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 05:34:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15F93BVc006167;
        Tue, 15 Jun 2021 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JDRuxLmqhikk3auTwq4KJxVRq+eD09nDtLO5y4WnjNk=;
 b=N9vtttvwu+8WsOtxiDDavsIfuEuaL1Uf/KI4SVO23RbQVlP7/LAIQ4a12ZKfxjTsTa6A
 ApRmGsazHbL//KYsftL/a025uy5MTVoaOqhxFItXq2lzo/ebR1Q5Rc/VKg73FiLW3iR9
 upKvpIbYMRTMIX7U4ZmHwEEbR0aKb7Oe5jLrnvtf1OV/DMC6SYYWB9a0wloWimEf4bQz
 VF0lKp3RNUaF1p+7Qj4uFeel3GbQEqp2qypbC0/P44WfjwCX8W+llqoBJYnjVGsr6Kzq
 XLXPW9oOZwbNUAxnPiXSXxeilelp+VXFRflBH9SCrI4iRBcSCxCm02QgwZA/CGQVj6XQ zw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 396rsahnvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:32:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15F9SwUK003674;
        Tue, 15 Jun 2021 09:31:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 394mj8scqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 09:31:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15F9UrGD35783056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 09:30:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E6AA4C050;
        Tue, 15 Jun 2021 09:31:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B8CE4C04A;
        Tue, 15 Jun 2021 09:31:55 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.173.127])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Jun 2021 09:31:55 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lt5QI-001Xkp-FB; Tue, 15 Jun 2021 11:31:54 +0200
Date:   Tue, 15 Jun 2021 11:31:54 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>
Subject: Re: [PATCH 06/15] scsi: zfcp: Use the proper SCSI midlayer
 interfaces for PI
Message-ID: <YMhzigPzefg/k2jE@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-7-martin.petersen@oracle.com>
 <YMdoondMcc31A2vJ@t480-pf1aa2c2.linux.ibm.com>
 <yq1eed3an0e.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq1eed3an0e.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NM15o0I2i2o_PvryCLUSZaZoc6ySsWLx
X-Proofpoint-GUID: NM15o0I2i2o_PvryCLUSZaZoc6ySsWLx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=783 mlxscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150054
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 14, 2021 at 10:27:57PM -0400, Martin K. Petersen wrote:
> > Out of curiosity, do you have any idea whether there is any storage
> > that offers DIF with a different Logical Block Size than 512 (I
> > haven't see any, although, that doesn't say much)? Just re-read some
> > parts of our HBA specs and we probably would be in trouble, if it
> > does, with how we do things here.
> 
> I have a few that are 4Kn+8. It wouldn't say these are very common, the
> 16-bit CRC isn't that great with 4K blocks.
> 
> To address the block size issue we defined a couple of new protection
> formats in NVMe. These allow for 32 and 64-bit CRCs, larger reference
> tags, etc. However, these enhancements have yet to percolate down into
> SCSI/SBC.

Oh, interesting. Thanks for sharing.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
