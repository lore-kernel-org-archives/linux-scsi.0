Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D96EC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E652B20706
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 00:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgF0ADk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 20:03:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgF0ADk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jun 2020 20:03:40 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R03ERn098022;
        Fri, 26 Jun 2020 20:03:35 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31ux051umt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 20:03:34 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05QNuIAW023053;
        Sat, 27 Jun 2020 00:03:30 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 31uus1yf3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Jun 2020 00:03:30 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05R03Sdw24183058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 00:03:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6CA67805E;
        Sat, 27 Jun 2020 00:03:29 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE98B78069;
        Sat, 27 Jun 2020 00:03:28 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.184.115])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 27 Jun 2020 00:03:28 +0000 (GMT)
Message-ID: <1593216207.10175.2.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: Avoid unnecessary iterations on __scsi_scan_target
From:   James Bottomley <jejb@linux.vnet.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Anjali Kulkarni <Anjali.K.Kulkarni@oracle.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 26 Jun 2020 17:03:27 -0700
In-Reply-To: <38cee464-7320-87a9-f55c-f0db4679fc0a@oracle.com>
References: <38cee464-7320-87a9-f55c-f0db4679fc0a@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 impostorscore=0 cotscore=-2147483648
 bulkscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006260170
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-06-26 at 16:53 -0700, Anjali Kulkarni wrote:
> There is a loop in scsi_scan_channel(), which calls
> __scsi_scan_target() 255 times, even when it has found a
> target/device on a
> lun in the first iteration; this ends up adding a 2 secs delay to the
> boot
> time. The for loop in scsi_scan_channel() adding 2 secs to boot time
> is as
> follows:
> 
> for (id = 0; id < shost->max_id; ++id) {
>      ...
>      __scsi_scan_target(&shost->shost_gendev, channel,
>                                order_id, lun, rescan);
> }
> 
> __scsi_scan_target() calls scsi_probe_and_add_lun() which calls
> scsi_probe_lun(), hence scsi_probe_lun() ends up getting called 255
> times.
> Each call of scsi_probe_lun() takes 0.007865 secs.
> 0.007865 multiplied by 255 = 2.00557 secs.
> By adding a break in above for loop when a valid device on lun is
> found,
> we can avoid this 2 secs delay improving boot time by 2 secs.
> 
> The flow of code is depicted in the following sequence of events:
> 
> do_scan_async() ->
>      do_scsi_scan_host()->
>          scsi_scan_host_selected() ->
>              scsi_scan_channel()
>                  __scsi_scan_target() -> this is called shost->max_id 
> times
>                                          (255 times)
>                      scsi_probe_and_add_lun-> this is called 255
> times
>                          scsi_probe_lun : called 255 times, each call
>                                           takes 0.007865 secs.

What HBA is this?  This code is for legacy scanning of busses which
require it, which is pretty much only SPI.  The max_id of even the
latest SPI bus should only be 16, so where is 255 coming from?

James

