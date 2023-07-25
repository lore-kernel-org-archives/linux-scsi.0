Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4B0EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 18:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjGYSll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 14:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjGYSli (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 14:41:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945A92139
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 11:41:36 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9928abc11deso975634566b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 11:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1690310495; x=1690915295;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0I788wohjQE8SsbGgdpMx1YFIP2lgTgr+yd7Aw2Cjck=;
        b=b0pM0eFQWipjwvBA5rAEgQYT74RBhMdHIMtBF/Ievwknq0XgMDXN5xsJePKnz7vJNI
         rWPjk7fCOjEK52+9n3BtpCD0y9zCtP5LcUMruKr7o5/i77pHqJckQ8rbiUmKU/aOB4ir
         KhSAd3LCiSuGUyEDMSNTGxU3ky7ZrdH/yX9Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690310495; x=1690915295;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0I788wohjQE8SsbGgdpMx1YFIP2lgTgr+yd7Aw2Cjck=;
        b=ao6X5gVwcOGmgF2BvNE2bo9dRJMkLVSNdwAGDVgHLcb+9buYv9itTEpMyFYmEgsjmI
         QMN6PDhSggWqpc9lIhiJ1DiG+a86pi5QimR/sVnzOjYy83a6js4cIFpnm9nmjJSTCJpZ
         ui7/hYcjM3Pxemrq/849fYP30Ng8bVLjzoNy7alvVerElskXsLu4SEdi2bU20LJZnEWU
         qpKGwLg2v4FvalEY2jV/kzIqziQ9HLtBOmxKoJHW1npLfXfe6g52Dz1PKjt+3wh2uThL
         h1IGEV6G9Sz2SPXG9ip5TxqHbTUiG9UnGnOVTx2jjqslVRh97o50D8ZBIToIpkBTmv3b
         D8Lw==
X-Gm-Message-State: ABy/qLZXltXPwQnkxuaz/CuyFC7Pa0MCESvEHhq9zDOv6V9pD+zV37ma
        x1LiaDDHJTRfV3ZUZPByB/gcrmhTqweCEG5tjzVQ9C0q
X-Google-Smtp-Source: APBJJlFdW2FpO6JFq69q1R8C/hIuCOsAsecQgFxyP17bP3ftkVZ/25GIDwZrUSw7BeUvpNCYXpLgag==
X-Received: by 2002:a17:906:1046:b0:991:cd1f:e67a with SMTP id j6-20020a170906104600b00991cd1fe67amr14585381ejj.29.1690310494941;
        Tue, 25 Jul 2023 11:41:34 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id k20-20020a1709065fd400b009934b1eb577sm8651755ejv.77.2023.07.25.11.41.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 11:41:34 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-52222562f1eso4750562a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 11:41:34 -0700 (PDT)
X-Received: by 2002:aa7:d282:0:b0:522:29b2:e048 with SMTP id
 w2-20020aa7d282000000b0052229b2e048mr7180205edq.13.1690310493829; Tue, 25 Jul
 2023 11:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiu-dX+CGUnhsk3KfPbP1h-1kCmVoTV6FEETQmafGWdLQ@mail.gmail.com>
 <9adfd67b-4327-9233-8e87-3fd5f3f7280b@cybernetics.com>
In-Reply-To: <9adfd67b-4327-9233-8e87-3fd5f3f7280b@cybernetics.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Jul 2023 11:41:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXgrO8dEYAQX6E8ffZXhzJ_+VPZyx1TcYpdRhQHD=L0A@mail.gmail.com>
Message-ID: <CAHk-=whXgrO8dEYAQX6E8ffZXhzJ_+VPZyx1TcYpdRhQHD=L0A@mail.gmail.com>
Subject: Re: SCSI: fix parsing of /proc/scsci/scsi file
To:     Tony Battersby <tonyb@cybernetics.com>
Cc:     Martin K Petersen <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>, Willy Tarreau <w@1wt.eu>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008ba2fe0601541426"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008ba2fe0601541426
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Jul 2023 at 11:27, Tony Battersby <tonyb@cybernetics.com> wrote:
>
> Something that I just thought of: the old parser could also skip over
> NUL characters used as separators within the buffer that aren't at the
> end of the buffer, as in: "host\0id\0channel\0lun".  If you want to
> continue to allow that unlikely usage, then my patch comparing p to the
> end pointer would work better.

Yeah, that would probably be better still. Ack on that.

That said, I just realized that *all* of this is completely
unnecessarily complicated. We allow up to a PAGE_SIZE, but you cannot
actually fill even *remotely* that much without using insane
zero-padding, and at that point you're not doing something useful,
you're trying to actively break something.

So the simple fix is to just limit the size of the buffer to slightly
less than PAGE_SIZE, and just pad more than one NUL character at the
end. Technically we're skipping four characters, and then we have the
last "real" NUL terminator, so 5 would be sufficient, but let's make
it easy for the compiler to just generate one single 64-bit store (or
two 32-bit ones) and clear 8 bytes.

IOW, we could do something *this* simple instead.

But I'm ok with your "track the end" version too.

             Linus

--0000000000008ba2fe0601541426
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lkin7m3i0>
X-Attachment-Id: f_lkin7m3i0

IGRyaXZlcnMvc2NzaS9zY3NpX3Byb2MuYyB8IDcgKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
c2NzaV9wcm9jLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9wcm9jLmMKaW5kZXggNGE2ZWIxNzQxYmUw
Li5kYTY2ZDkyNjAyMzIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3Byb2MuYworKysg
Yi9kcml2ZXJzL3Njc2kvc2NzaV9wcm9jLmMKQEAgLTQwOSw3ICs0MDksNyBAQCBzdGF0aWMgc3Np
emVfdCBwcm9jX3Njc2lfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IGNoYXIgX191c2Vy
ICpidWYsCiAJY2hhciAqYnVmZmVyLCAqcDsKIAlpbnQgZXJyOwogCi0JaWYgKCFidWYgfHwgbGVu
Z3RoID4gUEFHRV9TSVpFKQorCWlmICghYnVmIHx8IGxlbmd0aCA+IFBBR0VfU0laRS04KQogCQly
ZXR1cm4gLUVJTlZBTDsKIAogCWJ1ZmZlciA9IChjaGFyICopX19nZXRfZnJlZV9wYWdlKEdGUF9L
RVJORUwpOwpAQCAtNDIxLDEwICs0MjEsNyBAQCBzdGF0aWMgc3NpemVfdCBwcm9jX3Njc2lfd3Jp
dGUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IGNoYXIgX191c2VyICpidWYsCiAJCWdvdG8gb3V0
OwogCiAJZXJyID0gLUVJTlZBTDsKLQlpZiAobGVuZ3RoIDwgUEFHRV9TSVpFKQotCQlidWZmZXJb
bGVuZ3RoXSA9ICdcMCc7Ci0JZWxzZSBpZiAoYnVmZmVyW1BBR0VfU0laRS0xXSkKLQkJZ290byBv
dXQ7CisJbWVtc2V0KGJ1ZmZlciArIGxlbmd0aCwgMCwgOCk7CiAKIAkvKgogCSAqIFVzYWdlOiBl
Y2hvICJzY3NpIGFkZC1zaW5nbGUtZGV2aWNlIDAgMSAyIDMiID4vcHJvYy9zY3NpL3Njc2kK
--0000000000008ba2fe0601541426--
