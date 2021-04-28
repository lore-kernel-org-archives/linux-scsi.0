Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ED6C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED85461446
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhD1X25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 19:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhD1X25 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 19:28:57 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB114C06138B
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 16:28:11 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id 66so25916512qkf.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xxfTjzzV0hNUc6inQI97xrtwyrVrpgRNrJIHWY6fEKI=;
        b=iGRQjNQz554678yeZMqH87TLCOQUW6DdKu0aSnH8bp0JmtcBRDQku74TOi7fJMsiKP
         SAiTFkvM2ceSBqD2V0gUCHPNggkhQvQZmPW4kYzkq5u4F9bhdrT1gEQXsqgTQnxPDkfC
         pWFMsC5oR42FMvZPfP/67yKLjU7ShZxnwXFNHuMB37RT028f29M//zVuWEdbKbAJurN6
         QeMwn10dx+hXZGJuVe1bBHNZQZ8d72F3XV1AbOPutRdsqZtIXqMMKxMFuUUj6c9qNE0f
         uN5oMuMPP7Ev6sUJEhwSjiEd8VrsUBO0nQNK4Wt1Q94VHQ1pXKCKPL7mwslvL2nDg9gI
         cW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xxfTjzzV0hNUc6inQI97xrtwyrVrpgRNrJIHWY6fEKI=;
        b=EssK+6yfI52DwX5tyGtRwkOCh+U3oPmwaqfyVr7thknqdMmfaUHl6Lw8P9xl5siGvy
         xTTxAZ+mQxs3LKEqtAzEe4MI7DqkPS5sP6TmbRoMncfBOjjx5GB912saPhUlsnvFcNwr
         svjybJO2u3C2iB5YnS96af9NZD9Oof66xV0EbDh5WaXDU5wzoOL0NN91LK04uhvN9z9Y
         kuHWw1hQq4jt0iw6/woC35DrSbTND+a38cMPNN9RNMW/eM7Tr/EK0wwkboPTd4H0B9yu
         nuYIIRLtTRgb/hFOcSkA+7hMo0WWq7vtyUYAHKUSa5yLgQR27jLbh/1WONP7gJgGOh92
         vbzg==
X-Gm-Message-State: AOAM531wYazhSSESsCJDdqFot+wmpt+Q8hCrfuEFmLTQVwch07eHgrFt
        7xmPwerpd3P/s+9Y/VDlZlL6570+jcTsmGuwZ3eKMw==
X-Google-Smtp-Source: ABdhPJxGhfSAMt6BMnAurl4gdwRKUfx8ln1FY00Ipc2XOQncrAih3swHQsknrARilzu8Ohqu3av0RYHWy1KVub6KFpI=
X-Received: by 2002:a37:6713:: with SMTP id b19mr31911585qkc.493.1619652490767;
 Wed, 28 Apr 2021 16:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210424221755.124438-1-michael.christie@oracle.com> <20210424221755.124438-7-michael.christie@oracle.com>
In-Reply-To: <20210424221755.124438-7-michael.christie@oracle.com>
From:   Khazhy Kumykov <khazhy@google.com>
Date:   Wed, 28 Apr 2021 16:27:59 -0700
Message-ID: <CACGdZY+907WUewc=ioHyB41F097nqy1GaAZhOw6bS5TarMP-jQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] scsi: iscsi_tcp: start socket shutdown during conn stop
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bharath Ravi <rbharath@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000066f09705c110bb21"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000066f09705c110bb21
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 24, 2021 at 3:18 PM Mike Christie
<michael.christie@oracle.com> wrote:
>
> Make sure the conn socket shutdown starts before we start the timer
> to fail commands to upper layers.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 553e95ad6197..1bc37593c88f 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
>         if (!sock)
>                 return;
>
> +       /*
> +        * Make sure we start socket shutdown now in case userspace is up
> +        * but delayed in releasing the socket.
> +        */
> +       kernel_sock_shutdown(sock, SHUT_RDWR);
> +
>         sock_hold(sock->sk);
>         iscsi_sw_tcp_conn_restore_callbacks(conn);
>         sock_put(sock->sk);
> --
> 2.25.1
>

For the series,
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>

--00000000000066f09705c110bb21
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmAYJKoZIhvcNAQcCoIIPiTCCD4UCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggzyMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
MEvaI7F4ZN2DM20wTAYDVR0gBEUwQzBBBgkrBgEEAaAyASgwNDAyBggrBgEFBQcCARYmaHR0cHM6
Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADCBmgYIKwYBBQUHAQEE
gY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2NhL2dzYXRsYXNy
M3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgwFoAUfMwKaNei6x4schvRzV2V
b4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9jYS9nc2F0
bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEBAIKZMQsUIWBTlSa6tHLU5L8W
YVOXfTkEXU6aeq8JjYjcj1fQD+1K0EQhvwz6SB5I0NhqfMLyQBUZHJXChsLGygbCqXbmBF143+sK
xsY5En+KQ03HHHn8pmLHFMAgvO2f8cJyJD3cBi8nMNRia/ZMy2jayQPOiiK34RpcoyXr80KWUZQh
iqPea7dSkHy8G0Vjeo4vj+RQBse+NKpyEzJilDUVpd5x307jeFjYBp2fLWt0UAZ8P2nUeSPjC2fF
kGXeiYWeVPpQCSzowcRluUVFrKApZDZpm3Ly7a5pMVFQ23m2Waaup/DHnJkgxlRQRbcxDhqLKrJj
tATPzBYapBLXne4xggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIzIFNNSU1FIENBIDIwMjACEAH+
DkXtUaeOlUVJH2IZ1xgwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJjHEGpG8Z+u
FZRcNQc6xhMiqqz0NBOsIAT9uKNnWme7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTIxMDQyODIzMjgxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJ
YIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcN
AQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAeV5TMcv4xzqPLEvSbnazgtXKQgCDt
QI0M0eoAPKZZGukJWGupxhHniZcobRB21rdbTw8BD8xiTpNshIloDpNvk03mkq/aHpCLVgBgVudp
0n2P4dhhQR3K/nEJfgCUGgchB/+JEk1IrKRK5nngwfQd+8BF4/4GZvSrEvfVgEt86IFJLdE9jCj1
lc3ZlgftCnAgk5zSyFnhlYcirT+Qihx1oak9zLlan8B7gi/dfmPdTEzYzt6nowIhiv0WoPP43wSj
VBN28dObid1C2XD4+TI1Hpd+AD+OF6GN7FbT0vzeNxJzal4fmLkdHpifSCQkbEKx6+qOp0K4plvX
bk5d/zgX
--00000000000066f09705c110bb21--
