Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5367C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jul 2022 08:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbiGWIFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Jul 2022 04:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiGWIFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2022 04:05:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDF5A1AA;
        Sat, 23 Jul 2022 01:05:12 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26N7rUe7038366;
        Sat, 23 Jul 2022 08:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o8CikSBRZTU8Lm0kRlvumOjhDN5GkmQan1RQt7HGrp8=;
 b=cse8gRutOri7g7hP3Z9cxX0ype42ppwrdganPTG2KHlgADfuP4ZvjlSFoovVudQ+M3eo
 JvsYAunI+Nw/Cm/q5U2nlbr2WGQ2VZmrcZNxve33w7gqWbyWUHwLpv4IfFP7tPFGu+0h
 IE1hKKhOHKHC+V9WcaxZSdSrOOqi5khLGh9BhAe1wFjPJLik8SIeSIj6Yb641CIHWPNi
 ackK0ppI4lNMoxFN0p0qLHNMxc1RcY2TJIhUrn9/nJzPh0yFoTR3Gw6T8OfHwMwjAwyR
 82fWt8/6Wto5l9yVSHWTNDhS3hEVr5n/1xFtgHCwCZiDpT4H2+ozBr6oLU2TNidgfHc0 iw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hgd05r56j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Jul 2022 08:05:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26N7bELL019447;
        Sat, 23 Jul 2022 07:47:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3hg97t85x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Jul 2022 07:47:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26N7jUtd21365166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jul 2022 07:45:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895375204F;
        Sat, 23 Jul 2022 07:47:22 +0000 (GMT)
Received: from [9.145.77.4] (unknown [9.145.77.4])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DEE575204E;
        Sat, 23 Jul 2022 07:47:21 +0000 (GMT)
Message-ID: <723e67b1-96b1-c691-78fb-7b86758a7092@linux.ibm.com>
Date:   Sat, 23 Jul 2022 09:47:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Content-Language: en-US
To:     Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Nilesh Javali <njavali@marvell.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
 <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
 <20220718152243.21ad13e7@gandalf.local.home>
 <20220719082514.egsqevbaxl7a4prx@carbon.lan>
 <65df89cd-0f86-9d11-2f31-da6b6e4a1de2@marvell.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <65df89cd-0f86-9d11-2f31-da6b6e4a1de2@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uy0yEyPnP8IJpmRKrxLOZcVbNH9dEo2a
X-Proofpoint-GUID: uy0yEyPnP8IJpmRKrxLOZcVbNH9dEo2a
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-22_06,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1011 malwarescore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207230035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 00:09, Arun Easi wrote:
> On Tue, 19 Jul 2022, 1:25am, Daniel Wagner wrote:
>> On Mon, Jul 18, 2022 at 03:22:43PM -0400, Steven Rostedt wrote:
>>> On Mon, 18 Jul 2022 12:02:26 -0700
>>> Arun Easi <aeasi@marvell.com> wrote:
>>>
>>>> Many times when a problem was reported on the driver, we had to request
>>>> for a repro with extended error logging (via driver module parameter)
>>>> turned on. With this internal tracing in place, log messages that appear
>>>> only with extended error logging are captured by default in the internal
>>>> trace buffer.
>>>>
>>>> AFAIK, kernel tracing requires a user initiated action to be turned on,
>>>> like enabling individual tracepoints. Though a script (either startup or
>>>> udev) can do this job, enabling tracepoints by default for a single
>>>> driver, I think, may not be a preferred choice -- particularly when the
>>>> trace buffer is shared across the kernel. That also brings the extra
>>>> overhead of finding how this could be done across various distros.
>>>>
>>>> For cases where the memory/driver size matters, there is an option to
>>>> compile out this feature, plus choosing a lower default trace buffer size.
>>
>> I am really asking the question why do we need to add special debugging
>> code to every single driver? Can't we try to make more use of generic
>> code and extend it if necessary?
>>
>> Both FC drivers qla2xxx and lpfc are doing their own thing for

All three FC drivers:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/s390/scsi/zfcp_dbf.c

We have this flight recorder (multiple topical ring buffers per vHBA to avoid 
some higher frequency topics lose history of others) since a long time [maybe 
pre-dating ftrace], including crash tool support to extract it from post mortem 
kernel dumps. We use binary trace records, like tracepoints, with offline 
decoding/formatting (zfcpdbf in s390-tools package).
Other s390 kernel components share the underlying s390dbf infrastructure.

The crash extension "ftrace" is probably able to do an export from dump for the 
approach Steven suggested. I had used it with kernel function tracer. Very useful.

>> debugging/logging and I really fail to see why we can't not move towards
>> a more generic way. Dumping logs to the kernel log was the simplest way
>> but as this series shows, this is not something you can do in production
>> systems.
> 
> No contention here on a generic way. The per instance trace creation and
> enabling from within the kernel looks like such a one. Let me revisit the
> trace patches with this new info.
> 
> Regards,
> -Arun
> 
>>
>>> You can enable an ftrace instance from inside the kernel, and make it a
>>> compile time option.
>>>
>>> 	#include <linux/trace_events.h>
>>> 	#include <linux/trace.h>
>>>
>>> 	struct trace_array *tr;
>>>
>>> 	tr = trace_array_get_by_name("qla2xxx");
>>> 	trace_array_set_clr_event(tr, "qla", NULL, true);
>>>
>>> And now you have trace events running:
>>>
>>>   # cat /sys/kernel/tracing/instances/qla/trace
>>
>> Thanks Steve for the tip!
>>
>> Daniel
>>


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
