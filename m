Return-Path: <SRS0=TURL=6D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA544C38A30
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 18:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B345B21744
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 18:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDSSWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Apr 2020 14:22:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgDSSWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Apr 2020 14:22:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03JI2Cnj013736
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2020 14:22:11 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu66t80-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2020 14:22:10 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sun, 19 Apr 2020 19:21:20 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 19 Apr 2020 19:21:17 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03JIM5An53149730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Apr 2020 18:22:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A224C04A;
        Sun, 19 Apr 2020 18:22:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDFE74C040;
        Sun, 19 Apr 2020 18:22:04 +0000 (GMT)
Received: from [9.145.37.10] (unknown [9.145.37.10])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 19 Apr 2020 18:22:04 +0000 (GMT)
Subject: Re: [PATCH v4 06/14] scsi_debug: implement pre-fetch commands
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
References: <20200225062351.21267-1-dgilbert@interlog.com>
 <20200225062351.21267-7-dgilbert@interlog.com> <yq1eesrvvrk.fsf@oracle.com>
 <045764e7-277c-d81c-9e73-dc9fa9ab22b5@interlog.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Sun, 19 Apr 2020 20:22:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <045764e7-277c-d81c-9e73-dc9fa9ab22b5@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20041918-0020-0000-0000-000003CABCEC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041918-0021-0000-0000-00002223AD0F
Message-Id: <aac5d33f-5280-3660-8059-e3a154f29979@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-19_04:2020-04-17,2020-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190153
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19.04.20 20:01, Douglas Gilbert wrote:
> On 2020-04-13 6:57 p.m., Martin K. Petersen wrote:
>>
>> Doug,
>>
>>> Many disks implement the SCSI PRE-FETCH commands. One use case might
>>> be a disk-to-disk compare, say between disks A and B.  Then this
>>> sequence of commands might be used: PRE-FETCH(from B, IMMED),
>>> READ(from A), VERIFY (BYTCHK=1 on B with data returned from READ). The
>>> PRE-FETCH (which returns quickly due to the IMMED) fetches the data
>>> from the media into B's cache which should speed the trailing VERIFY
>>> command.  The next chunk of the compare might be done in parallel,
>>> with A and B reversed.
>>
>> Minor nit: I agree with the code and the use case. But the commit
>> description should reflect what the code actually does (not much in the
>> absence of cache, etc.)
> 
> On reflection, there is no reason why the implementation of PRE-FETCH
> for a scsi_debug ramdisk can't do what it implies. IOWs get those blocks
> into (say) the machine's L3 cache. This is to speed a following
> VERIFY(BYTCHK=1) [or NVMe Compare ***] that will use those blocks. The
> question is, how?
> 
> I have added this to resp_pre_fetch():
>    memcpm(ramdisk_ptr, ramdisk_ptr, num_blks*blk_sz);
> 
> Will that be optimized out? If so, is there a better/faster way to
> encourage a machine to populate its cache?
> 

Have a look at prefetch_range() ?


> Doug Gilbert
> 
> 
> *** I have a recent WD SN550 SSD whose sequential read speed (after
>     data (zeros) written) is around 1200 MB/sec. Its read speed _before_
>     data was written was around 25 KB/sec !! And its compare speed
>     (with random data written) is a very disappointing 25 MB/sec.
> 
> 

