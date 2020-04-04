Return-Path: <SRS0=8r17=5U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0B9C2BA17
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Apr 2020 11:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 726DD20719
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Apr 2020 11:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jNWrS2na"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDDLPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Apr 2020 07:15:53 -0400
Received: from mout.web.de ([212.227.17.12]:55557 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgDDLPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 4 Apr 2020 07:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1585998895;
        bh=XaTOEXnC3yHGMSOTnTJjcLY1jIeKJX78T/9fo8XYUog=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=jNWrS2naAasfW/j5mHa8mPmQsq+o3j+ZO3O0ZMeIC3L2EKVUsKN12PLEzdd2YqphA
         PpDItuSqOycM1hEf9U8VdlytOVtVcAkiu/+ThTcOThnxculrvv4Yy1bbTuhg4LQmuj
         fNSU+H1CqypKNYBf14RjKko784GSuB5jStCH2xQ8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.132.181.229]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MHXxg-1jJZlS2wkG-003MqF; Sat, 04
 Apr 2020 13:14:54 +0200
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Remove unnecessary calls to memset after
 dma_alloc_coherent
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Alex Dewar <alex.dewar@gmx.co.uk>,
        Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Chaitra Basappa <chaitra.basappa@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Fontana <rfontana@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com,
        MPT-FusionLinux.pdl@broadcom.com
Message-ID: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
Date:   Sat, 4 Apr 2020 13:14:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4dgcvqMPX/wM1DiRFLqWvWQRTYFDe0QbQ9Ckgj7kvxX4veaGUHi
 tASOrG9BqrzzkXdMd8xrBAcZ5zGv7yeBj7jRfzZvPNFMCoruY+nt5liQ7vupveqfKiv0obp
 xeCbAfX3M8ZSGFpdt8IkvzcXw75IsoJPTPQEcatpmJa+vB7uEf6ka50FQ7RueRAuyrfWjxB
 YJ+lhQf/DearDdLdnJe+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5lfCi9erITk=:6h6u3PvMeSNFVZD1LHtvP5
 wvLNnZCI4+2aARVbQ+JVU9j4LT6uTvt098vkadL0SJHp7rsuNda7BmLb8/+4+OTbFUpqhHZq5
 YKvQmQlX0QB8fDAwoZc2b4mqCwE0rFUoqvA8Hu/N7cazgLQ/Cdq3Jvy/ufZlEKcerGwyHd1xY
 d50BY3FicNPCfJWwEcyQq2x90+45O2PTIliaIA0guOlwZWovUIeIqnC2luVITGzEIr0K3GbQ4
 R14g8Jd9jIIXJSzkAw33sKVOWnp5tmK8mXh3gYlDgYNioRPoy1jwUd1XEp0pXCFG8Env9CjJr
 tvSU+BU6XZ9hXAz7cPZFzPiZ+YKo4GjnyFCm6xWZheKk2BLsAl9un82cMQOr41Saa1piMjtfn
 Rfg5FRaNblmDIrE6EQHDD5XCyFI/spomZioXNYyHQ/2+EhT/YvtTiVsgmSQq0eqOGFyOC+iG4
 ZjyZ4wYunC3FCowKdwavEpVuiUmbNe/dmCtPBPEF0OpZQlIMuOnv8jpVeOIOpvuasOhI+n+Ui
 gyZ4kJL0brxbCL4vZUiNA2oK/l0kSGSX44PBxkwRFmkhLG5o5P1RxJNxTH7I8IefSRRYcZ7Tt
 RPRr8Ql/z5nl7UXijFsq80a2KfkGh4Rs0n4BcaL17gOsym/7SRfpd//UtuMCejlAUBfVrgXfl
 4y4w0pBOkcOpCTTIPZ13C0memndX8ls4nc8w+d0rmArd+LTIx2x48FQw+Eaa99bPA1V3cgwOl
 DXZoe+M9PAozTmKISXbQQey0YUknyIZKpvRq8XVc1zFrpmXhXY+r4VGqgsf/AIKBsPUI9yOIW
 dEJSFlrUxXO7ssFSw8I7NH7QssKL+qN9RLlLqDTMC1RXAcUPvXTnfIsE7x3rBdiOtkCtSezXt
 +4/n4kO2l8n0sfxdVwatNkHV5gHs1WwIYF4wK68u0x6sObLXHlXuA+T8MAM3yUrmGXvosfkr6
 tZZmLvLrAbypxCdbCkCFJqVjA4IXrk9+tqME5H+g8bI5Ux9YfaUs6+Od91WBaMW9EExYv80pr
 Wl02QkJl0Cj32jrhKb0tBYk2697b3mfwDlNM99DJTEQ7tV0/AF+WPTFIaJ+58YKSFSo2ZHlU3
 WzXB1LHrnzgQq9/8FxY0MFnnth0Lm4iMPvf8yh6dvRQ1EZo121zV4X41/YfHOeKi2i+zPwZ8r
 EK7sfW/h0jqWNbPkh3f1MKOvSdqf8N3oEt6QtHSaQM6oOyp9JsE8rD3hH/sTXtriwoIBEcvS+
 WkGCzagVWtsNs0mXj
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> dma_alloc_coherent() now zeroes memory after allocation, so additional
> calls to memset() afterwards are unnecessary. Remove them.

I suggest to reconsider the distribution of recipients also for this patch
according to the fields =E2=80=9CCc=E2=80=9D and =E2=80=9CTo=E2=80=9D.


=E2=80=A6
> +++ b/drivers/scsi/dpt_i2o.c
=E2=80=A6
> @@ -3067,13 +3064,12 @@ static int adpt_i2o_build_sys_table(void)
>  	sys_tbl_len =3D sizeof(struct i2o_sys_tbl) +	// Header + IOPs
>  				(hba_count) * sizeof(struct i2o_sys_tbl_entry);
>
> -	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev,
> -				sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
> +	sys_tbl =3D dma_alloc_coherent(&pHba->pDev->dev, sys_tbl_len,
> +				     &sys_tbl_pa, GFP_KERNEL);
>  	if (!sys_tbl) {
=E2=80=A6
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -244,28 +244,22 @@ static int mvs_alloc(struct mvs_info *mvi, struct =
Scsi_Host *shost)
=E2=80=A6
> -	mvi->slot =3D dma_alloc_coherent(mvi->dev,
> -				       sizeof(*mvi->slot) * slot_nr,
> +	mvi->slot =3D dma_alloc_coherent(mvi->dev, sizeof(*mvi->slot) * slot_n=
r,
>  				       &mvi->slot_dma, GFP_KERNEL);
>  	if (!mvi->slot)
=E2=80=A6
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -79,7 +79,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void *=
pkt)
>  	    (uint8_t *)abts, sizeof(*abts));
>
>  	rsp_els =3D dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els), &dma,
> -	    GFP_KERNEL);
> +				     GFP_KERNEL);
>  	if (!rsp_els) {
=E2=80=A6
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4887,15 +4887,13 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *=
vha)
>  	    "Entered %s.\n", __func__);
>
>  	els_cmd_map =3D dma_alloc_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
> -	    &els_cmd_map_dma, GFP_KERNEL);
> +					 &els_cmd_map_dma, GFP_KERNEL);
>  	if (!els_cmd_map) {
=E2=80=A6

I find it safer to integrate such source code reformattings by
another update step which will be separated from the proposed deletion
of unwanted function calls.

Regards,
Markus
