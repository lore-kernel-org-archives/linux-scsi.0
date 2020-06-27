Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED944C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B8E2080C
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgF0AWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 20:22:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14922 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgF0AWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jun 2020 20:22:06 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R03M7i010514;
        Fri, 26 Jun 2020 20:21:48 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31waw95326-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 20:21:48 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05R0FoB2022990;
        Sat, 27 Jun 2020 00:21:47 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 31uurtqk3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Jun 2020 00:21:47 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05R0LjAg25362816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 00:21:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0706D78063;
        Sat, 27 Jun 2020 00:21:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BEF67805C;
        Sat, 27 Jun 2020 00:21:46 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.184.115])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 27 Jun 2020 00:21:45 +0000 (GMT)
Message-ID: <1593217304.10175.4.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: Avoid unnecessary iterations on __scsi_scan_target
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Anjali Kulkarni <Anjali.K.Kulkarni@oracle.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 26 Jun 2020 17:21:44 -0700
In-Reply-To: <7917b23d-0222-d0c7-42a4-b3f18ac24ec2@oracle.com>
References: <38cee464-7320-87a9-f55c-f0db4679fc0a@oracle.com>
         <1593216207.10175.2.camel@linux.vnet.ibm.com>
         <7917b23d-0222-d0c7-42a4-b3f18ac24ec2@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 malwarescore=0 cotscore=-2147483648
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=996 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260166
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-06-26 at 17:17 -0700, Anjali Kulkarni wrote:
> Thanks James.
> 
> This is on a VM on OCI cloud, using virtio scsi.
> 
> Here is output of lspci on the VM:
> 
> 00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma]
> (rev 02)
> 00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA
> [Natoma/Triton II]
> 00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE 
> [Natoma/Triton II]
> 00:01.2 USB controller: Intel Corporation 82371SB PIIX3 USB 
> [Natoma/Triton II] (rev 01)
> 00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
> 00:02.0 VGA compatible controller: Device 1234:1111 (rev 02)
> 00:03.0 Ethernet controller: Red Hat, Inc. Virtio network device
> 00:04.0 SCSI storage controller: Red Hat, Inc. Virtio SCSI

I think the right thing to do would be to fix virtio-SCSI.  It already
has the guest to host communication to know how many targets are
configured.  There's shouldn't be any need to do scanning.

James

