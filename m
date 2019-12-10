Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A033C2D0BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D3AD207FF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 04:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j04JV50r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfLJEsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 23:48:45 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:38554 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfLJEsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 23:48:45 -0500
Received: by mail-io1-f41.google.com with SMTP id v3so350634ioj.5;
        Mon, 09 Dec 2019 20:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JqQAW5M+Dz64POoDX3kKE3QnRN5AZsvU4kacJVjWMM4=;
        b=j04JV50rUqL7yGGFbW3486OoTYcm+k/Ph4IrE8Wr5bzFIqw9Fu4P19kh6cS9+LZiBI
         uuwgj9CQC3kMZ4apOPi2gn6zamVxj+VryOEH7MDfiX2/1NVYnJLhZTB4VEbsp/Ax8OdQ
         9NqEOrde+mq24Rk6mLKGZe0vngnekkzuxdO6YqxtnFjpu1xDw3X1Qul+GExFEWHEyRMw
         RXKGO2TSQk94uW8BeOEiixKF+W7w62InRIWPG5KU35UJ0lJWWtGjq2X/WIz4hMFW9Lgf
         C5FjVtWJPNrv82aoCdvVFXgzhwG4lDdS1x3j8C89iNBxsF4h1kgT6o/I576gLBamaNDy
         7pVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JqQAW5M+Dz64POoDX3kKE3QnRN5AZsvU4kacJVjWMM4=;
        b=qCjCkjf97/NrHLoRGNVCbePKacpg1c/YEA2WvfUcvFaS2XK7qdPt+wj2Of5d8rNxix
         fQGVGm7dhMkzY56hthoTEQ31SmWgxZTna0vv2zaNUh3lkq5mtjiqcZJCYPgqHy3dkgQf
         JUIlP+CyPMQPFrDH0VK+X3PhS9lZ6SsH1dRJ1v6HXY93kV6EGAxNzhOpS6d3YJUstf2z
         KoaJ4wepOhiMKaergPYqgua3bfdOY7SYmyekVlB8PYAnOFhui+AceZCb8OGCNN3lj1fq
         X0IyBhYDjhz+Zon85e17Oe0HJfsnjCC2vUPTYHDDF9MVQdeHjYW7uRtErtkfgIbRiNij
         5TtA==
X-Gm-Message-State: APjAAAULSZwWDyM66lYoMomucPE6IbTZn8V5jhWv2Nz3RJuMhxOMs2nQ
        ZyLuw9XMotAv2iA7IfL8RohQrUt7fZL/M5YTujZQEU7d
X-Google-Smtp-Source: APXvYqyntXLSfPVP66IHT6eRdhPoTzNH7GkZzI4IZCWKH2x2QrDgqMvPQI3fzTaFKqL1SEz26LgGFxxJKZdJG6aEDp0=
X-Received: by 2002:a05:6638:762:: with SMTP id y2mr27583524jad.78.1575953324305;
 Mon, 09 Dec 2019 20:48:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Dec 2019 22:48:33 -0600
Message-ID: <CAH2r5muJSARbGJ4cOZoGy32mCtUTG9wyEyw8aF06zexshAmqfQ@mail.gmail.com>
Subject: [PATCH] smb3: fix refcount underflow warning on unmount when no
 directory leases
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>
Content-Type: multipart/mixed; boundary="000000000000140bee0599523ac1"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000140bee0599523ac1
Content-Type: text/plain; charset="UTF-8"

Fix refcount underflow warning when unmounting to servers which didn't grant
directory leases.

[  301.680095] refcount_t: underflow; use-after-free.
[  301.680192] WARNING: CPU: 1 PID: 3569 at lib/refcount.c:28
refcount_warn_saturate+0xb4/0xf3
...
[  301.682139] Call Trace:
[  301.682240]  close_shroot+0x97/0xda [cifs]
[  301.682351]  SMB2_tdis+0x7c/0x176 [cifs]
[  301.682456]  ? _get_xid+0x58/0x91 [cifs]
[  301.682563]  cifs_put_tcon.part.0+0x99/0x202 [cifs]
[  301.682637]  ? ida_free+0x99/0x10a
[  301.682727]  ? cifs_umount+0x3d/0x9d [cifs]
[  301.682829]  cifs_put_tlink+0x3a/0x50 [cifs]
[  301.682929]  cifs_umount+0x44/0x9d [cifs]

Fixes: 72e73c78c446 ("cifs: close the shared root handle on tree disconnect")

Signed-off-by: Steve French <stfrench@microsoft.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>

-- 
Thanks,

Steve

--000000000000140bee0599523ac1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-refcount-underflow-warning-on-unmount-when-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-refcount-underflow-warning-on-unmount-when-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k3zdwsyh0>
X-Attachment-Id: f_k3zdwsyh0

RnJvbSAyODEzOTM4OTRhZjljYzNmOTQ4MzIwNDQ3NTAxNGU4OWQ3Mjg5ODdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgOSBEZWMgMjAxOSAxOTo0NzoxMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBzbWIzOiBmaXggcmVmY291bnQgdW5kZXJmbG93IHdhcm5pbmcgb24gdW5tb3VudCB3aGVuIG5v
CiBkaXJlY3RvcnkgbGVhc2VzCgpGaXggcmVmY291bnQgdW5kZXJmbG93IHdhcm5pbmcgd2hlbiB1
bm1vdW50aW5nIHRvIHNlcnZlcnMgd2hpY2ggZGlkbid0IGdyYW50CmRpcmVjdG9yeSBsZWFzZXMu
CgpbICAzMDEuNjgwMDk1XSByZWZjb3VudF90OiB1bmRlcmZsb3c7IHVzZS1hZnRlci1mcmVlLgpb
ICAzMDEuNjgwMTkyXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAzNTY5IGF0IGxpYi9yZWZjb3VudC5j
OjI4CnJlZmNvdW50X3dhcm5fc2F0dXJhdGUrMHhiNC8weGYzCi4uLgpbICAzMDEuNjgyMTM5XSBD
YWxsIFRyYWNlOgpbICAzMDEuNjgyMjQwXSAgY2xvc2Vfc2hyb290KzB4OTcvMHhkYSBbY2lmc10K
WyAgMzAxLjY4MjM1MV0gIFNNQjJfdGRpcysweDdjLzB4MTc2IFtjaWZzXQpbICAzMDEuNjgyNDU2
XSAgPyBfZ2V0X3hpZCsweDU4LzB4OTEgW2NpZnNdClsgIDMwMS42ODI1NjNdICBjaWZzX3B1dF90
Y29uLnBhcnQuMCsweDk5LzB4MjAyIFtjaWZzXQpbICAzMDEuNjgyNjM3XSAgPyBpZGFfZnJlZSsw
eDk5LzB4MTBhClsgIDMwMS42ODI3MjddICA/IGNpZnNfdW1vdW50KzB4M2QvMHg5ZCBbY2lmc10K
WyAgMzAxLjY4MjgyOV0gIGNpZnNfcHV0X3RsaW5rKzB4M2EvMHg1MCBbY2lmc10KWyAgMzAxLjY4
MjkyOV0gIGNpZnNfdW1vdW50KzB4NDQvMHg5ZCBbY2lmc10KCkZpeGVzOiA3MmU3M2M3OGM0NDYg
KCJjaWZzOiBjbG9zZSB0aGUgc2hhcmVkIHJvb3QgaGFuZGxlIG9uIHRyZWUgZGlzY29ubmVjdCIp
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+CkFj
a2VkLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5
OiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpSZXZpZXdlZC1ieTogUGF2ZWwgU2hp
bG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+ClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IEFy
dGh1ciBNYXJzaCA8YXJ0aHVyLm1hcnNoQGludGVybm9kZS5vbi5uZXQ+Ci0tLQogZnMvY2lmcy9z
bWIycGR1LmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1
LmMKaW5kZXggMGFiNmIxMjAwMjg4Li5kMjY1OGY1MWZmNjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0xODQ3LDcgKzE4NDcsOCBAQCBT
TUIyX3RkaXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbikK
IAlpZiAoKHRjb24tPm5lZWRfcmVjb25uZWN0KSB8fCAodGNvbi0+c2VzLT5uZWVkX3JlY29ubmVj
dCkpCiAJCXJldHVybiAwOwogCi0JY2xvc2Vfc2hyb290KCZ0Y29uLT5jcmZpZCk7CisJaWYgKHRj
b24tPmNyZmlkLmlzX3ZhbGlkKQorCQljbG9zZV9zaHJvb3QoJnRjb24tPmNyZmlkKTsKIAogCXJj
ID0gc21iMl9wbGFpbl9yZXFfaW5pdChTTUIyX1RSRUVfRElTQ09OTkVDVCwgdGNvbiwgKHZvaWQg
KiopICZyZXEsCiAJCQkgICAgICZ0b3RhbF9sZW4pOwotLSAKMi4yMy4wCgo=
--000000000000140bee0599523ac1--
