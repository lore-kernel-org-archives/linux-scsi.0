Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CDFC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 22:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C4823435
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 22:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbhANWso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:48:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14872 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbhANWso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 17:48:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EMWbKG040426;
        Thu, 14 Jan 2021 17:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7JxhRXjgGQMFAWopEZRfNvYgI8wAHRs5ArdqbBGBpWI=;
 b=P+zQ5Lm++6HPAYPyV88xIlqGyKcpcv01DxKPNObzzI3xOoOlvPC8EwcRXFVs2TGf/E6c
 7MOVHYHRar1dIzonyctNifpNCpOX6E2qhjTimNm8z3rK+ICv6T5PsSEaGvVaxM3zVNAq
 Az9SkEjqY27uDgFG8E2Vpl64C5M2H33ciWzY2QCOCOPNTT8NbNQPtFSF1IdrD75gtxCH
 XBx0Q+yN+Cucv8uPRV2GMLDvc76I0xhHiSs+L4bq87F4f7j2Mz9CHI1a7CaB0fl5mwhL
 rdrWLT1psb2VwyfWmecsMKZKsjPYRFliv432HoZsBVkrJ54iMgbG5SP/I5PqV1580eRr nQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362vwr3cx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 17:47:55 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EMlsjK019940;
        Thu, 14 Jan 2021 22:47:54 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 35y449gg3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 22:47:54 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EMlr7o38601210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 22:47:53 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B39DC7017;
        Thu, 14 Jan 2021 22:47:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0933EC7016;
        Thu, 14 Jan 2021 22:47:52 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.16.139])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 22:47:52 +0000 (GMT)
Subject: Re: [PATCH v5 00/21] ibmvfc: initial MQ development/enablement
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <4e35505e-20a7-0b55-23dc-5d0972526e77@linux.vnet.ibm.com>
Date:   Thu, 14 Jan 2021 16:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_10:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tyrel,

I think this patch series is looking pretty good. I don't think we need
to wait for resolution of the can_queue issue being discussed, since
that is an issue that exists prior to this patch series and this patch
series doesn't make the issue any worse. Let's work that separately.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

