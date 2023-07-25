Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC92C001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 17:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjGYRbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjGYRa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 13:30:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD75E3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:30:53 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99454855de1so849156566b.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1690306252; x=1690911052;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8YN90U0y2k0M2aE2B56swcEJYHG48HYNScT8gjLzv1g=;
        b=OtCDhHkjbr+7s6r6dvvZ8tjowEwo7soFehYRLisESZnOmuab77UqJshxSb8CnBCGgy
         xD4Qxsj7DOCQo1BN30pQa7pQkNpKQm74CgtGcbf2L9FfHj7ni1LrGYiBGqUSBvr7w4AN
         1jAhJequNF4wD2fRWBp6qKdZrrh5j8aJE8OWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690306252; x=1690911052;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8YN90U0y2k0M2aE2B56swcEJYHG48HYNScT8gjLzv1g=;
        b=HDaWzDlcNoDaD0qFTsZf/wZJBpm+REG9UcA3xw7KQ3yrwO/WxgRGi2hJJVGJ6kcVsp
         5J/HzTmi9DwPvlizfDvK7wFeQK1JjvROy8BDA2oHTeFVq88Z1iAs/LVcYBFMunMayytA
         dBBokdPZBqe+8QTGrPcdsHHazil8QAkdmEEryEzK+bxwwuWvc1LwgyshX3sFdRKjf3py
         Df/To79SmikMd7ukazeNTOulGHuIU5e0Da0WfI3TqET/njNYaC2wtWXUYtp0ujmMU/zO
         dWHpuMWEkqgyXMgDBn2zhfL1yWpGGh+SJBlG4qDhQ07BV4LJBHJMaqldMtgd6a7+n117
         BwUw==
X-Gm-Message-State: ABy/qLYI9AJb1uH7Zakel39lJCJIpI2zhAZ4ckHiZ4gG0zbvLW524FQb
        XDd1C/kDba5ELmz8SYK+D0d5J09f6/wyaaZJWchpha/B
X-Google-Smtp-Source: APBJJlFQDKUlQATPXYJZ5tIZUR8xLJ2JdnYT2rE4yACx82Foy95o65RmtZ38W5h52qlMQdir6FNH6A==
X-Received: by 2002:a17:906:25e:b0:991:d8b2:ea31 with SMTP id 30-20020a170906025e00b00991d8b2ea31mr13543790ejl.52.1690306252204;
        Tue, 25 Jul 2023 10:30:52 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id jx21-20020a170906ca5500b00988a0765e29sm8428329ejb.104.2023.07.25.10.30.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 10:30:51 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-51d95aed33aso8286327a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:30:51 -0700 (PDT)
X-Received: by 2002:a05:6402:2052:b0:522:3cf4:9d86 with SMTP id
 bc18-20020a056402205200b005223cf49d86mr3657239edb.33.1690306251162; Tue, 25
 Jul 2023 10:30:51 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Jul 2023 10:30:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiu-dX+CGUnhsk3KfPbP1h-1kCmVoTV6FEETQmafGWdLQ@mail.gmail.com>
Message-ID: <CAHk-=wiu-dX+CGUnhsk3KfPbP1h-1kCmVoTV6FEETQmafGWdLQ@mail.gmail.com>
Subject: SCSI: fix parsing of /proc/scsci/scsi file
To:     Martin K Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Willy Tarreau <w@1wt.eu>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a9c3f706015317bc"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a9c3f706015317bc
Content-Type: text/plain; charset="UTF-8"

This is the simplified version of the fix proposed by Tony Battersby
for the horrid scsi /proc parsing code.

It doesn't make it prettier, it just makes it less buggy. That parsing
code hasn't been changed in git or BK times, so it's at least two
decades since anybody touched it, and judging by how nasty it is, it's
probably more than that.

This is v2 with the additional bug noted by Tony hopefully fixed.

             Linus

--000000000000a9c3f706015317bc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-scsi-fix-legacy-proc-parsing-buffer-overflow.patch"
Content-Disposition: attachment; 
	filename="0001-scsi-fix-legacy-proc-parsing-buffer-overflow.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lkikoaqw0>
X-Attachment-Id: f_lkikoaqw0

RnJvbSA1NzRmZTI2OWY1YWFmNjJhM2VjODYyYmY0MzBhZGY5MWEyMDgyM2JkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IFR1ZSwgMjUgSnVsIDIwMjMgMTA6MDk6MzEgLTA3MDAKU3ViamVjdDog
W1BBVENIXSBzY3NpOiBmaXggbGVnYWN5IC9wcm9jIHBhcnNpbmcgYnVmZmVyIG92ZXJmbG93CgpU
aGUgcGFyc2luZyBjb2RlIGZvciAvcHJvYy9zY3NpL3Njc2kgaXMgZGlzZ3VzdGluZyBhbmQgYnJv
a2VuLiAgV2UKc2hvdWxkIGhhdmUganVzdCB1c2VkICdzc2NhbmYoKScgb3Igc29tZXRoaW5nIHNp
bXBsZSBsaWtlIHRoYXQsIGJ1dCB0aGUKbG9naWMgbWF5IGFjdHVhbGx5IHByZWRhdGUgb3VyIGtl
cm5lbCBzc2NhbmYgbGlicmFyeSByb3V0aW5lIGZvciBhbGwgSQprbm93LiAgSXQgY2VydGFpbmx5
IHByZWRhdGVzIGJvdGggZ2l0IGFuZCBCSyBoaXN0b3JpZXMuCgpBbmQgd2UgY2FuJ3QgY2hhbmdl
IGl0IHRvIGJlIHNvbWV0aGluZyBzYW5lIGxpa2UgdGhhdCBub3csIGJlY2F1c2UgdGhlCnN0cmlu
ZyBtYXRjaGluZyBhdCB0aGUgc3RhcnQgaXMgZG9uZSBjYXNlLWluc2Vuc2l0aXZlbHksIGFuZCB0
aGUKc2VwYXJhdG9yIHBhcnNpbmcgYmV0d2VlbiBudW1iZXJzIGlzbid0IGRvbmUgYXQgYWxsLCBz
byAqYW55KiBzZXBhcmF0b3IKd2lsbCB3b3JrLCBpbmNsdWRpbmcgYSBwb3NzaWJsZSB0ZXJtaW5h
dGluZyBOVUwgY2hhcmFjdGVyLgoKVGhpcyBpbnRlcmZhY2UgaXMgcm9vdC1vbmx5LCBhbmQgZW50
aXJlbHkgZm9yIGxlZ2FjeSB1c2UsIHNvIHRoZXJlIGlzCmFic29sdXRlbHkgbm8gcG9pbnQgaW4g
dHJ5aW5nIHRvIHRpZ2h0ZW4gdXAgdGhlIHBhcnNpbmcuICBCZWNhdXNlIGFueQpzZXBhcmF0b3Ig
aGFzIHRyYWRpdGlvbmFsbHkgd29ya2VkLCBpdCdzIGVudGlyZWx5IHBvc3Npb2JsZSB0aGF0IHBl
b3BsZQpoYXZlIHVzZWQgcmFuZG9tIGNoYXJhY3RlcnMgcmF0aGVyIHRoYW4gdGhlIHN1Z2dlc3Rl
ZCBzcGFjZS4KClNvIGRvbid0IGJvdGhlciB0byB0cnkgdG8gcHJldHR5IGl0IHVwLCBhbmQgbGV0
J3MganVzdCBtYWtlIGEgbWluaW1hbApwYXRjaCB0aGF0IGNhbiBiZSBiYWNrLXBvcnRlZCBhbmQg
d2UgY2FuIGZvcmdldCBhYm91dCB0aGlzIHdob2xlIHNvcnJ5CnRoaW5nIGZvciBhbm90aGVyIHR3
byBkZWNhZGVzLgoKSnVzdCBtYWtlIGl0IGF0IGxlYXN0IG5vdCB0cmF2ZXJzZSB0aGUgdGVybWlu
YXRpbmcgTlVMLgoKUmVwb3J0ZWQtYnk6IFRvbnkgQmF0dGVyc2J5IDx0b255YkBjeWJlcm5ldGlj
cy5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNjc2kvYjU3MGY1ZmUt
Y2I3Yy04NjNhLTZlZDktZjY3NzRjMjE5Yjg4QGN5YmVybmV0aWNzLmNvbS8KQ2M6IE1hcnRpbiBL
IFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KQ2M6IEphbWVzIEJvdHRvbWxl
eSA8amVqYkBsaW51eC5pYm0uY29tPgpDYzogV2lsbHkgVGFycmVhdSA8d0Axd3QuZXU+CkNjOiBz
dGFibGVAa2VybmVsLm9yZwpTaWduZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNA
bGludXgtZm91bmRhdGlvbi5vcmc+Ci0tLQogZHJpdmVycy9zY3NpL3Njc2lfcHJvYy5jIHwgMjMg
KysrKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCsp
LCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9wcm9jLmMg
Yi9kcml2ZXJzL3Njc2kvc2NzaV9wcm9jLmMKaW5kZXggNGE2ZWIxNzQxYmUwLi44YWE4MjA4Y2Vi
N2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3Byb2MuYworKysgYi9kcml2ZXJzL3Nj
c2kvc2NzaV9wcm9jLmMKQEAgLTM4Myw2ICszODMsOSBAQCBzdGF0aWMgaW50IHNjc2lfcmVtb3Zl
X3NpbmdsZV9kZXZpY2UodWludCBob3N0LCB1aW50IGNoYW5uZWwsIHVpbnQgaWQsIHVpbnQgbHVu
KQogCXJldHVybiBlcnJvcjsKIH0KIAorLyogaW5jcmVtZW50ICdwJywgYnV0IG5vdCBwYXN0IHRo
ZSBlbmQgKi8KK3N0YXRpYyBpbmxpbmUgY2hhciAqbmV4dF9wKGNoYXIgKnApIHsgcmV0dXJuIHAg
KyAhISpwOyB9CisKIC8qKgogICogcHJvY19zY3NpX3dyaXRlIC0gaGFuZGxlIHdyaXRlcyB0byAv
cHJvYy9zY3NpL3Njc2kKICAqIEBmaWxlOiBub3QgdXNlZApAQCAtNDMxLDEyICs0MzQsMTIgQEAg
c3RhdGljIHNzaXplX3QgcHJvY19zY3NpX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBj
aGFyIF9fdXNlciAqYnVmLAogCSAqIHdpdGggICIwIDEgMiAzIiByZXBsYWNlZCBieSB5b3VyICJI
b3N0IENoYW5uZWwgSWQgTHVuIi4KIAkgKi8KIAlpZiAoIXN0cm5jbXAoInNjc2kgYWRkLXNpbmds
ZS1kZXZpY2UiLCBidWZmZXIsIDIyKSkgewotCQlwID0gYnVmZmVyICsgMjM7CisJCXAgPSBidWZm
ZXIgKyAyMjsKIAotCQlob3N0ID0gc2ltcGxlX3N0cnRvdWwocCwgJnAsIDApOwotCQljaGFubmVs
ID0gc2ltcGxlX3N0cnRvdWwocCArIDEsICZwLCAwKTsKLQkJaWQgPSBzaW1wbGVfc3RydG91bChw
ICsgMSwgJnAsIDApOwotCQlsdW4gPSBzaW1wbGVfc3RydG91bChwICsgMSwgJnAsIDApOworCQlo
b3N0ID0gc2ltcGxlX3N0cnRvdWwobmV4dF9wKHApLCAmcCwgMCk7CisJCWNoYW5uZWwgPSBzaW1w
bGVfc3RydG91bChuZXh0X3AocCksICZwLCAwKTsKKwkJaWQgPSBzaW1wbGVfc3RydG91bChuZXh0
X3AocCksICZwLCAwKTsKKwkJbHVuID0gc2ltcGxlX3N0cnRvdWwobmV4dF9wKHApLCAmcCwgMCk7
CiAKIAkJZXJyID0gc2NzaV9hZGRfc2luZ2xlX2RldmljZShob3N0LCBjaGFubmVsLCBpZCwgbHVu
KTsKIApAQCAtNDQ1LDEyICs0NDgsMTIgQEAgc3RhdGljIHNzaXplX3QgcHJvY19zY3NpX3dyaXRl
KHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBjaGFyIF9fdXNlciAqYnVmLAogCSAqIHdpdGggICIw
IDEgMiAzIiByZXBsYWNlZCBieSB5b3VyICJIb3N0IENoYW5uZWwgSWQgTHVuIi4KIAkgKi8KIAl9
IGVsc2UgaWYgKCFzdHJuY21wKCJzY3NpIHJlbW92ZS1zaW5nbGUtZGV2aWNlIiwgYnVmZmVyLCAy
NSkpIHsKLQkJcCA9IGJ1ZmZlciArIDI2OworCQlwID0gYnVmZmVyICsgMjU7CiAKLQkJaG9zdCA9
IHNpbXBsZV9zdHJ0b3VsKHAsICZwLCAwKTsKLQkJY2hhbm5lbCA9IHNpbXBsZV9zdHJ0b3VsKHAg
KyAxLCAmcCwgMCk7Ci0JCWlkID0gc2ltcGxlX3N0cnRvdWwocCArIDEsICZwLCAwKTsKLQkJbHVu
ID0gc2ltcGxlX3N0cnRvdWwocCArIDEsICZwLCAwKTsKKwkJaG9zdCA9IHNpbXBsZV9zdHJ0b3Vs
KG5leHRfcChwKSwgJnAsIDApOworCQljaGFubmVsID0gc2ltcGxlX3N0cnRvdWwobmV4dF9wKHAp
LCAmcCwgMCk7CisJCWlkID0gc2ltcGxlX3N0cnRvdWwobmV4dF9wKHApLCAmcCwgMCk7CisJCWx1
biA9IHNpbXBsZV9zdHJ0b3VsKG5leHRfcChwKSwgJnAsIDApOwogCiAJCWVyciA9IHNjc2lfcmVt
b3ZlX3NpbmdsZV9kZXZpY2UoaG9zdCwgY2hhbm5lbCwgaWQsIGx1bik7CiAJfQotLSAKMi40MS4w
LjMyNy5nYWE5MTY2YmNjMAoK
--000000000000a9c3f706015317bc--
