Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F6BC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B4120738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="PvBA2+UX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgGMMDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 08:03:16 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.5]:44548 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728714AbgGMMDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 08:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594641791; i=@ts.fujitsu.com;
        bh=yhSSR7qg+pE8SmNPWkjJ/NF2m44tgnURWl3Sk2hN0as=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=PvBA2+UXKjHvGWpCjz/Qt2FPLUtY+sxeJ6Ks9WuNwfMBKJ0+DOR6DxwCWK0ZxcXsR
         vBTT3MXFLICpsifJqXkzwmN1ubBnP1XM1vZXBTQI8Ki5jg66WSBKvvTguwQ5tft+bG
         9AhE0AyneXnRtP6Rbzpp3DNUIkCZFn2Ym1VZ+I2raEo8Oc7daIVbLEmrdqdmrl5RfV
         Q1TUXKpyxpOsf5MILbCIgU1Q5rD2rgZm8q3YYjLhWPEP1zek8WHb0THKr8oKKJpqMU
         GS3d1SagWWRvP5FqzKSS4yfUbB9d0+6l6CR5qJIeK9VzWmjJDEcypW9Ya061PXR3+8
         LuerL8pzQC6eg==
Received: from [100.113.2.20] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-a.eu-central-1.aws.symcld.net id AA/F9-13954-E7D4C0F5; Mon, 13 Jul 2020 12:03:10 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRWlGSWpSXmKPExsViZ8MxVbfOlyf
  e4MFeNYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxqPddQVf
  tSp2Tr7C2MB4XbWLkYtDSGAyo0Rf5zomCKefUeLrnY9sXYycHMICXhJr/s5hA0mICKxhlFj0e
  ilU1VJGiYP/loNVsQkYSKyYdJ8FxOYVcJQ4ffgMM4jNIqAq8XHLP8YuRg4OUYFwiWcr/CFKBC
  VOznwCVs4pYCex+ctMsHJmATOJeZsfQtniEreezGeCsLUlli18zTyBkW8WkvZZSFpmIWmZhaR
  lASPLKkbLpKLM9IyS3MTMHF1DAwNdQ0NjXUNdI2MzvcQq3US91FLd5NS8kqJEoKxeYnmxXnFl
  bnJOil5easkmRmBApxQyvtnB+PX1B71DjJIcTEqivAUePPFCfEn5KZUZicUZ8UWlOanFhxhlO
  DiUJHjnewLlBItS01Mr0jJzgNEFk5bg4FES4bXzAkrzFhck5hZnpkOkTjEqSonzWoAkBEASGa
  V5cG2wiL7EKCslzMvIwMAgxFOQWpSbWYIq/4pRnINRSZh3FcgUnsy8Erjpr4AWMwEt5vnHCbK
  4JBEhJdXANHc9u0yO5MnMjMsGXi9/7Yuwdv7SlhzUsvZV8vNN5pKGtvFlbOLfLi5ePTm6XnlS
  2JMn7ybF9sQa/Ll/lYfBZjZDx8ZQw+nSDb8f7JhuEyUYHFJxn2WZ9KkUwY6MszInyqvPLT/4v
  rtH+rd7Qly7nZWGhufaGZqfE78t/3CG9Vw9q3airOHM1X8TJ6fMcD9gYxcY89XspItxVN+1ut
  11BmxtTtVrtW48qRYt+uXzIDZi1gnb/JsCQifnJ0z0UOTMZFfcbBnPyuU9wWjb86m5x49cn3+
  yNWWC3en1HzfOZmd5ybJ8xasrrGuXZz/kiV58Iyawnq9LfptTUEvqDaUHubLPQ1cyuk8rFN7+
  Uni/EktxRqKhFnNRcSIABS6+Z2MDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-7.tower-228.messagelabs.com!1594641790!1051113!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1854 invoked from network); 13 Jul 2020 12:03:10 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-7.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 13 Jul 2020 12:03:10 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06DC397c024110;
        Mon, 13 Jul 2020 13:03:09 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 811BD20375;
        Mon, 13 Jul 2020 14:03:06 +0200 (CEST)
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
 <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
Date:   Mon, 13 Jul 2020 14:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-12 03:15, Mike Christie wrote:
> On 7/10/20 5:48 AM, Bodo Stroesser wrote:

...

>> @@ -844,6 +854,9 @@ static bool is_ring_space_avail(struct tcmu_dev=20
>> *udev, struct tcmu_cmd *cmd,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 if (!data_needed)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return true;
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* try to check and get the data blocks=
 as needed */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 space =3D spc_bitmap_free(udev->data_bi=
tmap, udev->dbi_thresh);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((space * DATA_BLOCK_SIZE) < data_ne=
eded) {
>> @@ -1106,6 +1119,61 @@ static int queue_cmd_ring(struct tcmu_cmd=20
>> *tcmu_cmd, sense_reason_t *scsi_err)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;
>> =C2=A0 }
>> +/*
>=20
> We do 2 stars for this type of comment:
>=20
> /**
>=20
>> + * queue_tmr_ring - queue tmr info to ring or internally
>> + *
>=20
> No extra newline.
>=20

Ah, thank you. I'll fix both.
>> @@ -1141,6 +1209,85 @@ static void tcmu_set_next_deadline(struct=20
>> list_head *queue,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 del_timer(timer=
);
>> =C2=A0 }
>> +static int
>> +tcmu_tmr_type(enum tcm_tmreq_table tmf)
>> +{
>> +=C2=A0=C2=A0=C2=A0 switch (tmf) {
>> +=C2=A0=C2=A0=C2=A0 case TMR_ABORT_TASK:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return TCMU_TMR_ABORT_TASK;
>> +=C2=A0=C2=A0=C2=A0 case TMR_ABORT_TASK_SET:=C2=A0=C2=A0=C2=A0 return =
TCMU_TMR_ABORT_TASK_SET;
>> +=C2=A0=C2=A0=C2=A0 case TMR_CLEAR_ACA:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return TCMU_TMR_CLEAR_ACA;
>> +=C2=A0=C2=A0=C2=A0 case TMR_CLEAR_TASK_SET:=C2=A0=C2=A0=C2=A0 return =
TCMU_TMR_CLEAR_TASK_SET;
>> +=C2=A0=C2=A0=C2=A0 case TMR_LUN_RESET:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return TCMU_TMR_LUN_RESET;
>> +=C2=A0=C2=A0=C2=A0 case TMR_TARGET_WARM_RESET:=C2=A0=C2=A0=C2=A0 retu=
rn TCMU_TMR_TARGET_WARM_RESET;
>> +=C2=A0=C2=A0=C2=A0 case TMR_TARGET_COLD_RESET:=C2=A0=C2=A0=C2=A0 retu=
rn TCMU_TMR_TARGET_COLD_RESET;
>> +=C2=A0=C2=A0=C2=A0 case TMR_LUN_RESET_PRO:=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return TCMU_TMR_LUN_RESET_PRO;
>> +=C2=A0=C2=A0=C2=A0 default:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return TCMU_TMR_UNKNOWN;
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>> +static void
>> +tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head *cmd_list=
)
>> +{
>> +=C2=A0=C2=A0=C2=A0 int i =3D 0, cmd_cnt =3D 0;
>> +=C2=A0=C2=A0=C2=A0 bool unqueued =3D false;
>> +=C2=A0=C2=A0=C2=A0 uint16_t *cmd_ids =3D NULL;
>> +=C2=A0=C2=A0=C2=A0 struct tcmu_cmd *cmd;
>> +=C2=A0=C2=A0=C2=A0 struct se_cmd *se_cmd;
>> +=C2=A0=C2=A0=C2=A0 struct tcmu_tmr *tmr;
>> +=C2=A0=C2=A0=C2=A0 struct tcmu_dev *dev =3D TCMU_DEV(se_dev);
>> +
>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&dev->cmdr_lock);
>> +
>> +=C2=A0=C2=A0=C2=A0 // First we check for aborted commands in qfull_qu=
eue
>=20
> I know the coding style doc does not say to never use // anymore, but=20
> just use the same style we have already in the rest of the code for=20
> single line comments:
>=20
> /* comment */
>=20
>=20

Ok, I'll fix.

>> +struct tcmu_tmr_entry {
>> +=C2=A0=C2=A0=C2=A0 struct tcmu_cmd_entry_hdr hdr;
>> +
>> +#define TCMU_TMR_UNKNOWN=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>> +#define TCMU_TMR_ABORT_TASK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 1
>> +#define TCMU_TMR_ABORT_TASK_SET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 2
>> +#define TCMU_TMR_CLEAR_ACA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
3
>> +#define TCMU_TMR_CLEAR_TASK_SET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 4
>> +#define TCMU_TMR_LUN_RESET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
5
>> +#define TCMU_TMR_TARGET_WARM_RESET=C2=A0=C2=A0=C2=A0 6
>> +#define TCMU_TMR_TARGET_COLD_RESET=C2=A0=C2=A0=C2=A0 7
>> +/* Pseudo reset due to received PR OUT */
>> +#define TCMU_TMR_LUN_RESET_PRO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 128
>> +=C2=A0=C2=A0=C2=A0 __u8 tmr_type;
>> +
>> +=C2=A0=C2=A0=C2=A0 __u8 __pad1;
>> +=C2=A0=C2=A0=C2=A0 __u16 __pad2;
>> +=C2=A0=C2=A0=C2=A0 __u32 cmd_cnt;
>> +=C2=A0=C2=A0=C2=A0 __u64 __pad3;
>> +=C2=A0=C2=A0=C2=A0 __u64 __pad4;
>> +=C2=A0=C2=A0=C2=A0 __u16 cmd_ids[0];
>> +} __packed;
>> +
>=20
> Is this new request and the tmr_notify callback just supposed to clean=20
> up the requested commands or is it supposed to perform the actions of=20
> the task management function defined in the specs?
>=20
> The callback name makes it feel like it's just a notification, but the=20
> names above make it seem like we are supposed to execute the TMF in=20
> userspace. But if the latter, then how do we notify the kernel if the=20
> TMF was successful or failed?

My plan is to have a notification only. IMHO userspace (and also tcmu
or another backend) must not interfere with core's TMR handling.
The new callback tmr_notify just allows backend to be helpful during
TMR handling by completing in core aborted, but in backend/userspace
still running commands early.

Do you refer to the TCMU_TMR_* definitions? I just defined these names
because TMR_* definitions are in target_core_base.h which is not exposed
to userspace programs. Knowing the type of TMR that aborted a command is
useful at least for userspace tracing.

BTW: I hope there are enough padding fields in the tcmu_tmr_entry to
allow additional session info later?
