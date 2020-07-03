Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9725BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 16:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE0B20870
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 16:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h7ECNdjP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgGCQba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 12:31:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgGCQb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 12:31:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063GMNN5188163;
        Fri, 3 Jul 2020 16:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3JbXoamMJlD4q7a1MdUp0rYPdIRipvRbXsoR1txJ4rE=;
 b=h7ECNdjPjAek8wt2ayoOdFYWaysy+l2A5hqUFo5WW9U2yuhNr2vuutTANtbFApQnOlZb
 2QezTREJxsruNJ+MH9pdrxKOS/W44txu1VeMm6sf9PFWTj54bub4iEoQOHmwMjTIUaRI
 gl+tF5I78BiL3ZsaAMvAtSqW9KwZW50ZdtzGejO/C/E8jyosI9qtUNzaOLA6XqJIYOk9
 C77xy7zmdbhvyYr5eoiSekfmcUMrTQa2DfWUg2nNFbzsdH0Heipbnkp8diXOYQ+95N9B
 aHhyh6IOFpLFrH+G7jm3QoI/U0gtg67IOanH8TcKnRM8y63122RyzV0UHL+AHlfXFmPw /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1eb9dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 16:31:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063GSvxb036062;
        Fri, 3 Jul 2020 16:29:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52pk449-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 16:29:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063GTF8v013795;
        Fri, 3 Jul 2020 16:29:15 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 16:27:51 +0000
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>, hare@suse.de,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
Date:   Fri, 3 Jul 2020 11:27:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030112
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/3/20 7:51 AM, Bodo Stroesser wrote:
> On 2020-06-27 06:35, Mike Christie wrote:
>> This patch exports the LIO sessions via configfs. If userspace makes
>> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
>> supports the new interface on that TPG, then the kernel will make a
>> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir
> 
> I someone creates a new ACL on a running tpg, can it happen that a
> session already is created before user can create the sessions folder?

Right now yes. In the patch I started to try to support a per tpg mix. If a session exists then you do mkdir sessions, then before you can delete the tpg you have to delete the sessions that were created after the mkdir.

But to handle all the side cases, it becomes a pain, and I don't think anyone will ever use that feature, so I plan to make it either on or off for all sessions on the tpg and no mixing. I think normally we see different tools at the per target or per fabric level, so we should be ok.


> 
>> It works similar to how some targets export their session info today
>> where if it's dynamic session then it goes in the tpg dir and if
>> there is an ACL then it goes in the acl's sessions dir. The name of
>> the dir is "session-$sid".
>>
>> qla2xxx example:
>>
>> For ACL based sessions:
>>
>> ├── 21:00:00:24:ff:46:b8:88
>> │   ├── fabric_statistics
>> │   └── tpgt_1
>> │       ├── acls
>> │       │   └── 21:00:00:24:ff:46:b8:8a
>> │       │       └── sessions
>> │       │           └── session-1
>>
>>
>> or for a dynamic session it would be in the tpg dir
>> .....
>>
>> │       ├── param
>> │       └── sessions
>> │           └── session-1
>>
>>
>>
>> There is currently nothing in the session-$sid dir. To make the RFC
>> easier to read I did not post the transport id patches or the iscsi
>> conversion one, but on the final send I'll include them.
>>
>> Note/Warning:
>>
>> The interface has 2 quirks:
>>
>> 1. It works similar to the loop/vhost/usb/xen nexus file interface
>> where instead of a rmdir to delete the session you write to some special
>> file. For this new interface we have:
>>
>> /fabric/target/tpgt/sessions/remove_session
>>
>> 2. Because the kernel is making the session, there is no mkdir/rmdir
>> support for each session like other objects like LUN, tpg, target, np,
>> etc. But, before we remove the parent tpg, we have to remove the
>> children sessions still. This gives configfs the behavior it expects
>> where parents can't be removed before children and we will not hit
>> issues like we hit before.
> 
> If I got it right, before user can remove a tpg from sysFS, he first
> has to remove all existing sessions by writing the SIDs to the new
> remove_sessions file.

Yes.

> 
> But how do you prevent initiator side from quickly creating a new
> session e.g. in case of FC? Can we end up in a loop of session removal
> and re-creation, especially in case of multiple session an the same tpg?

No. It works the same as today. When you do a tpg removal like when you do

targetlci clearconfig

rtslib disables the tpg which prevents the target from creating new sessions. We then bring down the objects under it like luns, portals, etc. When we get to sessions, if the target has not yet brought them down (some targets do this on tpg disablement and some do not), then with that github patch rtslib will kill them like it does for the other objects.
