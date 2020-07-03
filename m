Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7213C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 16:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0061208FE
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 16:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="TSc3rxHM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgGCQ50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 12:57:26 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.66]:56606 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgGCQ5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 12:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593795442; i=@ts.fujitsu.com;
        bh=GCowboozjnhORJMhffnjz04UfqF8CFyi7nT8qqmuXhU=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=TSc3rxHMnHmJOF1gG+jfibxDcTRK9wW1GfQyR0ITVuDZJOfQpdBMzs9jik1ZACHem
         YtqaOAqSiOaVmibdn3qLqL+dbvlR7yqFw4sD2zANaHpxeO6uGHmdv572JWArSSB4hu
         O0tZ+7UTk7NmxK81CzWS5kWhG0yntLKRRBSKAfEmjUzZjHCTY0Q8Y8n97PHHNvajw2
         zD+4B5poPh8OKslL04srvlEL3cvA25l69AolO5z3CT4zxpY5FYWnYDZ5tfUyN0ebhu
         DUPino3oTU/Znksb2jkSl2PQmu8/iYA/PjMkKzI+gRPpf+9HqhwMwMCFH1M7A6RWoD
         n/kMAuYMz6+YA==
Received: from [100.112.197.119] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-west-1.aws.symcld.net id 67/0B-38618-2736FFE5; Fri, 03 Jul 2020 16:57:22 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRWlGSWpSXmKPExsViZ8MxVbcw+X+
  cwdZd+hbTPvxkttizaBKTRff1HWwWy4//Y7L4O+kGq0Xr0rdMDmwel694e3x8eovFY/Ppao/P
  m+QCWKJYM/OS8isSWDPeNVxnLmhVqFh5+jRTA+MFiS5GLg4hgUmMEltPNTJDOP2MEk2bPgI5n
  BzCAs4Sl65sZQRJiAhsZ5SY/+g3C0TVd0aJN92nWUCq2AQMJFZMug9m8wo4SjRu+gtmswioSP
  x7MAmom4NDVCBc4tkKf4gSQYmTM5+AlXAK2El8236ZCcRmFlCX+DPvEjOELS5x68l8qLi8xPa
  3c5gnMPLNQtI+C0nLLCQts5C0LGBkWcVokVSUmZ5RkpuYmaNraGCga2hopGtoaaZrZGisl1il
  m6SXWqpbnlpcomuol1herFdcmZuck6KXl1qyiREY9CkFR67uYOx+80HvEKMkB5OSKK9Z3P84I
  b6k/JTKjMTijPii0pzU4kOMMhwcShK8TElAOcGi1PTUirTMHGAEwqQlOHiURHiZQdK8xQWJuc
  WZ6RCpU4y6HLc3LFnELMSSl5+XKiXO+yMRqEgApCijNA9uBCwZXGKUlRLmZWRgYBDiKUgtys0
  sQZV/xSjOwagkzPsMZApPZl4J3KZXQEcwAR3hJf8P5IiSRISUVANTyv55s1h2Bwe2Kye/yE84
  OiNgndTpab68/7Lurv0dMyH/4tfnxybsDvf4oGmTYLXtPLMi17K3IerJvo+zLyqXqz5doC74/
  pJ/ywWlCf85uvN61B5vCOmY0T/hDPeD8zNS1ilfZ19Z8zfk1Nmca43K654In1BOvrDx4mS5vQ
  I2nK2eixp1TV89meQisn9VrrLTy88RuyY8M1/PcTj64cPpabu4jyx8+qd3jvtK6b9y7VHpSzJ
  /GYhd1Ah8IOGzufdyroPFawfBGX8cugN2ecbGMEe69/vyaEf/2zzvz3KRtt3aoUlvGyLXx7dJ
  fw09FZHcwHCv8GB3+tsy9f5znVv4owQf+X+Xz7s9d8LW61MqlViKMxINtZiLihMBjRKe6YEDA
  AA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-291.messagelabs.com!1593795441!792536!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16768 invoked from network); 3 Jul 2020 16:57:21 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-7.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 3 Jul 2020 16:57:21 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 063GvFaa008737;
        Fri, 3 Jul 2020 17:57:18 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 2918C204A1;
        Fri,  3 Jul 2020 18:57:12 +0200 (CEST)
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
To:     Mike Christie <michael.christie@oracle.com>, hare@suse.de,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
 <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
Date:   Fri, 3 Jul 2020 18:57:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-03 18:27, Mike Christie wrote:
> On 7/3/20 7:51 AM, Bodo Stroesser wrote:
>> On 2020-06-27 06:35, Mike Christie wrote:
>>> This patch exports the LIO sessions via configfs. If userspace makes
>>> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
>>> supports the new interface on that TPG, then the kernel will make a
>>> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir
>>
>> I someone creates a new ACL on a running tpg, can it happen that a
>> session already is created before user can create the sessions folder?
> 
> Right now yes. In the patch I started to try to support a per tpg mix. If a session exists then you do mkdir sessions, then before you can delete the tpg you have to delete the sessions that were created after the mkdir.
> 
> But to handle all the side cases, it becomes a pain, and I don't think anyone will ever use that feature, so I plan to make it either on or off for all sessions on the tpg and no mixing. I think normally we see different tools at the per target or per fabric level, so we should be ok.

Maybe I don't get it. What I meant is:

Creation of the "sessions" folders in tpg and acl has to be done by
user.
If user creates a new acl while tpg is active, the acl immediately
becomes active, I think.
If user then creates the "sessions" folder, it could happen that
a session already is started meanwhile. That session would be
invisible then.
Maybe an "enable" attr for acl would help?

.....

> No. It works the same as today. When you do a tpg removal like when you do
> 
> targetlci clearconfig
> 
> rtslib disables the tpg which prevents the target from creating new sessions. We then bring down the objects under it like luns, portals, etc. When we get to sessions, if the target has not yet brought them down (some targets do this on tpg disablement and some do not), then with that github patch rtslib will kill them like it does for the other objects.
> 

Ahh, I see.




Let me resend another part of my response, that was far down:

>   }
>   +int target_cfgfs_register_session(struct se_portal_group *se_tpg,
> +                  struct se_session *se_sess)
> +{
> +    struct se_node_acl *se_nacl;
> +    int ret;
> +
> +    /*
> +     * If the fabric doesn't support close_session, there's no way for
> +     * userspace to clean up the session during nacl/tpg deletion.
> +     */
> +    if (!se_tpg->cfgfs_sess_supp || !se_tpg->se_tpg_tfo->close_session)
> +        return 0;

Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
tpg/sessions or any acl/sessions folder is created.
So what will happen here if e.g session for an acl is created while
only tpg/sessions exists?
Do we need an similar flag per acl also?
And if we have a per acl and the tpg flag I think they should be removed
when user removes an empty sessions folder.

> +
> +    se_nacl = se_sess->se_node_acl;
> +    if (se_nacl->dynamic_node_acl) {
> +        ret = configfs_register_group(&se_tpg->tpg_sess_group,
> +                          &se_sess->group);
> +    } else {
> +        ret = configfs_register_group(&se_nacl->acl_sess_group,
> +                          &se_sess->group);
> +    }
> +    if (ret)
> +        goto fail;

Do we have a possible race here? I think it would be better to first
call target_depend_item() and then register the new session's group.

> +
> +    /*
> +     * The session is not created via a mkdir like other objects. A
> +     * transport event like a login or userspace used the nexus file to
> +     * initiate creation. However, we want the same behavior as other
> +     * objects where we must remove the children before removing the
> +     * parent dir, so do a depend on the parent that is released when the
> +     * session is removed.
> +     */
> +    if (se_nacl->dynamic_node_acl) {
> +        ret = target_depend_item(&se_tpg->tpg_sess_group.cg_item);
> +    } else {
> +        ret = target_depend_item(&se_nacl->acl_sess_group.cg_item);
> +    }
> +    if (ret)
> +        goto unreg_cfgfs;
> +
> +    se_sess->added_to_cfgfs = true;
> +    return 0;
