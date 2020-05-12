Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C3C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF5F20722
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Z3lFjNRL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELLUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 07:20:13 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:48927 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgELLUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 07:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589282409; i=@ts.fujitsu.com;
        bh=y4wfNvl0uueqUoC8G65ELCqPZfMFddf1x6PcnMZiGbU=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=Z3lFjNRLwDu+t2+bZCMb4Nh0vC4qkScTiXrgxz52Hl2+HlsL/8VYsbKHfzXiuykKX
         O+qz0qNarA1ZaFX//5ZO6jcuEBee4xQJCSWe90ErBZRwvvCy6eKCS24QXJHUoKYEtw
         ADhmOal8ETYeJgg8iX/G2QD6RkJWz5EwvsjCePpwl0yCp7c+ArFeIgDcbgWE1rNrdT
         d1xgI6xX3CWwfLrr2Ap3IqPeoIH0JEXxvv8xs/rSpx+p4EZSRZYDLBNqCI2AbwIf4h
         L8yoUABBOfA58L57PDz4TFzGNpEuq4b+icyfRCAeV5U5RMBpevxYz6Ts/Rog8gQpEv
         ba0rY08XPX3mw==
Received: from [100.113.3.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id 5A/94-40520-8668ABE5; Tue, 12 May 2020 11:20:08 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRWlGSWpSXmKPExsViZ8MxVTejbVe
  cwZ2VKhbTPvxktmhevJ7NYs+iSUwW3dd3sFksP/6PyWL9kQ2MFq1L3zI5sHtcvuLtsX/uGnaP
  j09vsXi833eVzWPz6WqPz5vkAtiiWDPzkvIrElgzNk15zlgwX7Zi+dHlTA2M98W6GLk4hARmM
  Uo86mln7WLk5BAWcJW4v+4cK0hCRGALo8SD/4sZuxg5OJgFoiV+LxOAaGhkkrjwewkzSAObgI
  HEikn3WUBsXgFHiWntnxhBbBYBVYnvBz6ADRUVCJd4seUPK0SNoMTJmU/A6jkF7CTmTXvEBmI
  zC5hJzNv8kBnCFpe49WQ+E4QtL7H97RzmCYx8s5C0z0LSMgtJyywkLQsYWVYxWiQVZaZnlOQm
  ZuboGhoY6BoaGusa6pqb6yVW6SbqpZbqJqfmlRQlAiX1EsuL9Yorc5NzUvTyUks2MQIjIqWQ0
  XcH48W17/UOMUpyMCmJ8mo07YoT4kvKT6nMSCzOiC8qzUktPsQow8GhJMH7sBUoJ1iUmp5akZ
  aZA4xOmLQEB4+SCO82kDRvcUFibnFmOkTqFKOilDjvoxaghABIIqM0D64NlhAuMcpKCfMyMjA
  wCPEUpBblZpagyr9iFOdgVBLmPQMyhSczrwRu+iugxUxAix8+3wayuCQRISXVwFRr3nH1oKy1
  pFGi8cWZchKOrMIn2dp2Gii1GHRu6Jr85PjfiPdVCtPUc7wjonccm2f8moExY4ucy4JIk67Ue
  h5BLyf5y9dPlLP/fb8hd0NE8N7/33TnOG7/KMVhy3bHX2vN345fh+uvCrgnVsi1Hv30uDDii7
  cMe17i34ad5s/z2a+/n3R0ypJijuCQCcyHnM+/2fjuR7mB8s3Xj7SPLD77MbX51CZmx6Q01ze
  RJuZJl27emWF+8fKBX2uyZD9Hv+2y2TD1qIoc18bS1LvRs1wWmLHpRqzXPBH/u+BO1oITz+L8
  AiVPh+7x8HFp4/acJpMsvSOBXbnDz6r1+M7+f+dEmTZGaHdFeE2r/xknoMRSnJFoqMVcVJwIA
  Dv8etuDAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-25.tower-226.messagelabs.com!1589282407!942030!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21641 invoked from network); 12 May 2020 11:20:08 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-25.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 12 May 2020 11:20:08 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 04CBJDKS030821;
        Tue, 12 May 2020 12:19:18 +0100
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
To:     Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
 <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
 <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
 <5234c678-92e6-0689-1eca-aa0c252adf58@redhat.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <a1ca0d10-9011-52a6-f40b-dc5086d9e273@ts.fujitsu.com>
Date:   Tue, 12 May 2020 13:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
In-Reply-To: <5234c678-92e6-0689-1eca-aa0c252adf58@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/11/20 22:16, Mike Christie wrote:
> On 5/11/20 2:21 PM, Bart Van Assche wrote:
>> On 2020-05-11 11:39, Bodo Stroesser wrote:
>>> On 05/10/20 23:57, Mike Christie wrote:
>>>> This patch adds helpers to add/remove a dir per session. There is only 2
>>>> files/dirs initially.
>>>>
>>>
>>> ...
>>>
>>>> +
>>>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>>>> +                 struct se_session *se_sess)
>>>> +{
>>>> +    int ret;
>>>> +
>>>> +    /*
>>>> +     * Copy ACL name so we don't have to worry about mixing configfs
>>>> +     * and sysfs refcounts.
>>>> +     */
>>>> +    if (!se_sess->se_node_acl->dynamic_node_acl) {
>>>> +        se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
>>>> +                        GFP_KERNEL);
>>>> +        if (!se_sess->acl_name)
>>>> +            return -ENOMEM;
>>>> +    }
>>>> +
>>>> +    ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
>>>> +              se_sess->tpt_id->name, se_sess->sid);
>>>> +    if (ret) {
>>>> +        pr_err("Could not add session%d to sysfs. Error %d.\n",
>>>> +               se_sess->sid, ret);
>>>> +        goto free_acl_name;
>>>> +    }
>>>> +
>>>> +    ret = add_transport_id_attrs(se_sess);
>>>> +    if (ret)
>>>> +        goto del_kobj;
>>>> +
>>>> +    if (se_sess->tfo->session_attrs) {
>>>> +        ret = sysfs_create_group(&se_sess->kobj,
>>>> +                     se_sess->tfo->session_attrs);
>>>> +        if (ret)
>>>> +            goto rm_tpt_id_grps;
>>>> +    }
>>>> +
>>>> +    ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
>>>> +                se_sess->kobj.name);
>>>
>>> I would prefer to have links named "session-%d" or "%d" only, of course
>>> with se_sess->sid as the value for '%d'.
> 
> Yeah for the part of your comment that got chopped I can see your point.
> For the dynamic acl case (userspace did not create an ACL so the kernel
> made a tmp one), then doing session-$id will be easier for userspace to
> lookup a specific session since it does not know the initiator name and
> only knows the session id.

Yes, I meant, that "session-%d" or even "%d" only would be fine for the
links in scsi_target/sessions. When looking for a session if session-id
is known only, then this is easy to use.

Regarding the session folders in the tpgt_X folder, I think the "%s-%d"
format with acl or initiator name followed by the session-id would be
fine for both cases, with acl and with dynamic acl. Again the above
links can be used for dynamic acl lookup.

> 
>>
>> Isn't se_sess->sid a property that is filled in by the iSCSI target
>> driver only? Is se_sess->sid zero for all other target drivers than the
>> iSCSI target driver?
> 
> No, in this patch in transport_alloc_session() I added a common sid
> allocator so all sessions have a unique id across all targets.
> 
>>
>>> If userspace knows the session-id only, such names make it easier to
>>> find the corresponding link.
>>
>> Personally I prefer the %s-%d naming scheme. I think that naming scheme
>> has the following advantages:
>> 1. No need to run cat ... to retrieve the initiator name.
>> 2. It becomes possible to derive from the 'ls' output which initiators
>> created multiple sessions.
>> 3. All sessions created by the same initiator appear consecutively.
>>
> 
> Ccing Hannes, because he was also saying that we should use generic
> names like target-%X, session-$d, etc. If we change all the code to use
> generic names for the target/fabric/tpgt/session, then examples like #2
> or similar ones like using tree to see the topology from a SCSI'ish view
> would not work.
> 
> In the end, we have this issue with SCSI on the initiator side, and it's
> a pain, but not a show stopper.
> 
