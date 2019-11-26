Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C2AC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 07:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 290EB20727
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 07:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="Jn1bMqIC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKZHqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 02:46:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40147 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfKZHqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 02:46:15 -0500
Received: by mail-wm1-f68.google.com with SMTP id y5so2064177wmi.5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 23:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=ivV0MOARKV6t6O5U1kgFNlsYHAAfV/gzIR0DNh9S584=;
        b=Jn1bMqICTHmXrvcejfZBzLqP2MugyiSAVHyFikmR8d2WMXNKpE8s7wb6ncC3JCbCeq
         YHxgnoWyPaV46vYIwmizU/nMQVDmi7YN1/SGXiJ198zryhmvDvoDSarqNma3jfRxp91R
         zl2bEKlDZnM9qGppTUHOx9cQd+7rKAiiyiu4m5cvEb2JM7lFhXQLxT/a5aJZy5RWp5IY
         LU6V4UhujyEa27wf/irkrwyZlScHvSq/+xpr2tdgpvDfdAcNrMfLGSuNO0Z6TrAbByR/
         k1DtMCZ5m63FlGGqWpbqyRK9YV/PIkHzIv4xzNj8rt5jvonO5a+blVd5ibO9uvO9+xrw
         jc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=ivV0MOARKV6t6O5U1kgFNlsYHAAfV/gzIR0DNh9S584=;
        b=UM4WdSZrAyhKtgEqJr9e2IFeJ6IbKZwPQrvlnSIoATOme/bxe+O6E6lgq2dUdsROSq
         oVC+AgKny/cWjpHy7/VIhzCwO5j9tFyqjcbvgjNRfX2RRL0gLXmsXT2e6Fs5bhtcr/HC
         gWqmtC9oesl8q8x/GPSlF6aPW8ifphky7nEbbhme94sGagkvaub03n4U/61oIVigZEQO
         4GW6VCoElBVdGevrdK1UrFC7azMrAou5w7O79vr6Ngr5x6OpySRmTD5xhEHj6996LdO6
         rkTNcknj9apb6Zyk5mnvVYRRGdx/EUS26akIbVSUKyUJ0eyK7xKdDITegIcumofrq9OM
         p/QQ==
X-Gm-Message-State: APjAAAUUedEWDZoEIb5MHaM+RpE00NHJeWT17uRdBGBNMdBrm0Rb4Lp4
        3jLuyt6NGDu77jt4BC+O+EJeTQ==
X-Google-Smtp-Source: APXvYqzGfi9k/OWPVrhlqhdfC/C+qzS5iCZIOoqsmWZj/H8N1h5eHSOAH8N9jbrlEfIb9m8eBJYiag==
X-Received: by 2002:a7b:c347:: with SMTP id l7mr2870421wmj.48.1574754370227;
        Mon, 25 Nov 2019 23:46:10 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id s8sm13794150wrt.57.2019.11.25.23.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 23:46:08 -0800 (PST)
Message-ID: <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date:   Tue, 26 Nov 2019 08:46:07 +0100
In-Reply-To: <20191126023253.GA24501@ming.t460p>
References: <20191109222828.GA30568@ming.t460p>
         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
         <20191123072726.GC25356@ming.t460p>
         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
         <20191125102928.GA20489@ming.t460p>
         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
         <20191125151535.GA8044@ming.t460p>
         <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
         <20191126023253.GA24501@ming.t460p>
Content-Type: multipart/mixed; boundary="=-YOcvGz7g6+q9SlGm1fMm"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--=-YOcvGz7g6+q9SlGm1fMm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Il giorno mar, 26/11/2019 alle 10.32 +0800, Ming Lei ha scritto:
> On Mon, Nov 25, 2019 at 07:51:33PM +0100, Andrea Vai wrote:
> > Il giorno lun, 25/11/2019 alle 23.15 +0800, Ming Lei ha scritto:
> > > On Mon, Nov 25, 2019 at 03:58:34PM +0100, Andrea Vai wrote:
> > > 
> > > [...]
> > > 
> > > > What to try next?
> > > 
> > > 1) cat /sys/kernel/debug/block/$DISK/hctx0/flags
> > result:
> > 
> > alloc_policy=FIFO SHOULD_MERGE|2
> > 
> > > 
> > > 
> > > 2) echo 128 > /sys/block/$DISK/queue/nr_requests and run your
> copy
> > > 1GB
> > > test again.
> > 
> > done, and still fails. What to try next?
> 
> I just run 256M cp test

I would like to point out that 256MB is a filesize that usually don't
trigger the issue (don't know if it matters, sorry).

Another info I would provide is about another strange behavior I
noticed: yesterday I ran the test two times (as usual with 1GB
filesize) and took 2370s, 1786s, and a third test was going on when I
stopped it. Then I started another set of 100 trials and let them run
tonight, and the first 10 trials were around 1000s, then gradually
decreased to ~300s, and finally settled around 200s with some trials
below 70-80s. This to say, times are extremely variable and for the
first time I noticed a sort of "performance increase" with time.

>  to one USB storage device on patched kernel,
> and WRITE data IO is really in ascending order. The filesystem is
> ext4,
> and mount without '-o sync'. From previous discussion, looks that is
> exactly your test setting. The order can be observed via the
> following script:
> 
> #!/bin/sh
> MAJ=$1
> MIN=$2
> MAJ=$(( $MAJ << 20 ))
> DEV=$(( $MAJ | $MIN ))
> /usr/share/bcc/tools/trace -t -C \
>   't:block:block_rq_issue (args->dev == '$DEV') "%s %d %d", args-
> >rwbs, args->sector, args->nr_sector'
> 
> $MAJ & $MIN can be retrieved via lsblk for your USB storage disk.
> 
> So I think we need to check if the patch is applied correctly first.
> 
> If your kernel tree is managed via git,
yes it is,

>  please post 'git diff'.
attached. Is it correctly patched? thanks.


> Otherwise, share us your kernel version,
btw, is 5.4.0+

>  and I will send you one
> backported patch on the kernel version.
> 
> Meantime, you can collect IO order log via the above script as you
> did last
> time, then send us the log.

ok, will try; is it just required to run it for a short period of time
(say, some seconds) during the copy, or should I run it before the
beginning (or before the mount?), and terminate it after the end of
the copy? (Please note that in the latter case a large amount of time
(and data, I suppose) would be involved, because, as said, to be sure
the problem triggers I have to use a large file... but we can try to
better understand and tune this. If it can help, you can get an ods
file with the complete statistic at [1] (look at the "prove_nov19"
sheet)).

Thanks,
Andrea

[1]: http://fisica.unipv.it/transfer/kernelstats.zip

--=-YOcvGz7g6+q9SlGm1fMm
Content-Disposition: attachment; filename="git_diff.txt"
Content-Type: text/plain; name="git_diff.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

IyBnaXQgZGlmZgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1xLmMgYi9ibG9jay9ibGstbXEuYwpp
bmRleCBlYzc5MTE1NmU5Y2MuLjkyZDYwYTVlMWQxNSAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLW1x
LmMKKysrIGIvYmxvY2svYmxrLW1xLmMKQEAgLTE0NjUsNyArMTQ2NSwxMyBAQCBzdGF0aWMgdm9p
ZCBfX2Jsa19tcV9kZWxheV9ydW5faHdfcXVldWUoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgs
IGJvb2wgYXN5bmMsCiAgICAgICAgaWYgKHVubGlrZWx5KGJsa19tcV9oY3R4X3N0b3BwZWQoaGN0
eCkpKQogICAgICAgICAgICAgICAgcmV0dXJuOwogCi0gICAgICAgaWYgKCFhc3luYyAmJiAhKGhj
dHgtPmZsYWdzICYgQkxLX01RX0ZfQkxPQ0tJTkcpKSB7CisgICAgICAgLyoKKyAgICAgICAgKiBT
b21lIHNpbmdsZS1xdWV1ZSBkZXZpY2VzIG1heSBuZWVkIHRvIGRpc3BhdGNoIElPIGluIG9yZGVy
CisgICAgICAgICogd2hpY2ggd2FzIGd1YXJhbnRlZWQgZm9yIHRoZSBsZWdhY3kgcXVldWUgdmlh
IHRoZSBiaWcgcXVldWUKKyAgICAgICAgKiBsb2NrLiBOb3cgd2UgcmVwbHkgb24gc2luZ2xlIGhj
dHgtPnJ1bl93b3JrIGZvciB0aGF0LgorICAgICAgICAqLworICAgICAgIGlmICghYXN5bmMgJiYg
IShoY3R4LT5mbGFncyAmIChCTEtfTVFfRl9CTE9DS0lORyB8CisgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBCTEtfTVFfRl9TVFJJQ1RfRElTUEFUQ0hfT1JERVIpKSkgewog
ICAgICAgICAgICAgICAgaW50IGNwdSA9IGdldF9jcHUoKTsKICAgICAgICAgICAgICAgIGlmIChj
cHVtYXNrX3Rlc3RfY3B1KGNwdSwgaGN0eC0+Y3B1bWFzaykpIHsKICAgICAgICAgICAgICAgICAg
ICAgICAgX19ibGtfbXFfcnVuX2h3X3F1ZXVlKGhjdHgpOwpAQCAtMzA1NSw2ICszMDYxLDEwIEBA
IGludCBibGtfbXFfYWxsb2NfdGFnX3NldChzdHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnNldCkKICAg
ICAgICBpZiAoIXNldC0+b3BzLT5nZXRfYnVkZ2V0IF4gIXNldC0+b3BzLT5wdXRfYnVkZ2V0KQog
ICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7CiAKKyAgICAgICBpZiAoc2V0LT5xdWV1ZV9k
ZXB0aCA+IDEgJiYgKHNldC0+ZmxhZ3MgJgorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IEJMS19NUV9GX1NUUklDVF9ESVNQQVRDSF9PUkRFUikpCisgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsKKwogICAgICAgIGlmIChzZXQtPnF1ZXVlX2RlcHRoID4gQkxLX01RX01BWF9ERVBU
SCkgewogICAgICAgICAgICAgICAgcHJfaW5mbygiYmxrLW1xOiByZWR1Y2VkIHRhZyBkZXB0aCB0
byAldVxuIiwKICAgICAgICAgICAgICAgICAgICAgICAgQkxLX01RX01BWF9ERVBUSCk7CmRpZmYg
LS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYyBiL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5j
CmluZGV4IDkxYzAwN2QyNmMxZS4uZjAxMzYzMDI3NWM5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Nj
c2kvc2NzaV9saWIuYworKysgYi9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYwpAQCAtMTkwMiw2ICsx
OTAyLDkgQEAgaW50IHNjc2lfbXFfc2V0dXBfdGFncyhzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCkK
ICAgICAgICBzaG9zdC0+dGFnX3NldC5mbGFncyA9IEJMS19NUV9GX1NIT1VMRF9NRVJHRTsKICAg
ICAgICBzaG9zdC0+dGFnX3NldC5mbGFncyB8PQogICAgICAgICAgICAgICAgQkxLX0FMTE9DX1BP
TElDWV9UT19NUV9GTEFHKHNob3N0LT5ob3N0dC0+dGFnX2FsbG9jX3BvbGljeSk7CisgICAgICAg
aWYgKHNob3N0LT5ob3N0dC0+c3RyaWN0X2Rpc3BhdGNoX29yZGVyKQorICAgICAgICAgICAgICAg
c2hvc3QtPnRhZ19zZXQuZmxhZ3MgfD0gQkxLX01RX0ZfU1RSSUNUX0RJU1BBVENIX09SREVSOwor
CiAgICAgICAgc2hvc3QtPnRhZ19zZXQuZHJpdmVyX2RhdGEgPSBzaG9zdDsKIAogICAgICAgIHJl
dHVybiBibGtfbXFfYWxsb2NfdGFnX3NldCgmc2hvc3QtPnRhZ19zZXQpOwpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2Ivc3RvcmFnZS9zY3NpZ2x1ZS5jIGIvZHJpdmVycy91c2Ivc3RvcmFnZS9zY3Np
Z2x1ZS5jCmluZGV4IDU0YTNjODE5NWM5Ni4uZGYxNjc0ZDdmMGZjIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3VzYi9zdG9yYWdlL3Njc2lnbHVlLmMKKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS9zY3Np
Z2x1ZS5jCkBAIC02NTEsNiArNjUxLDE4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2NzaV9ob3N0
X3RlbXBsYXRlIHVzYl9zdG9yX2hvc3RfdGVtcGxhdGUgPSB7CiAgICAgICAgLyogd2UgZG8gb3Vy
IG93biBkZWxheSBhZnRlciBhIGRldmljZSBvciBidXMgcmVzZXQgKi8KICAgICAgICAuc2tpcF9z
ZXR0bGVfZGVsYXkgPSAgICAgICAgICAgIDEsCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbXEuYyBi
L2Jsb2NrL2Jsay1tcS5jCmluZGV4IGVjNzkxMTU2ZTljYy4uOTJkNjBhNWUxZDE1IDEwMDY0NAot
LS0gYS9ibG9jay9ibGstbXEuYworKysgYi9ibG9jay9ibGstbXEuYwpAQCAtMTQ2NSw3ICsxNDY1
LDEzIEBAIHN0YXRpYyB2b2lkIF9fYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZShzdHJ1Y3QgYmxr
X21xX2h3X2N0eCAqaGN0eCwgYm9vbCBhc3luYywKICAgICAgICBpZiAodW5saWtlbHkoYmxrX21x
X2hjdHhfc3RvcHBlZChoY3R4KSkpCiAgICAgICAgICAgICAgICByZXR1cm47CiAKLSAgICAgICBp
ZiAoIWFzeW5jICYmICEoaGN0eC0+ZmxhZ3MgJiBCTEtfTVFfRl9CTE9DS0lORykpIHsKKyAgICAg
ICAvKgorICAgICAgICAqIFNvbWUgc2luZ2xlLXF1ZXVlIGRldmljZXMgbWF5IG5lZWQgdG8gZGlz
cGF0Y2ggSU8gaW4gb3JkZXIKKyAgICAgICAgKiB3aGljaCB3YXMgZ3VhcmFudGVlZCBmb3IgdGhl
IGxlZ2FjeSBxdWV1ZSB2aWEgdGhlIGJpZyBxdWV1ZQorICAgICAgICAqIGxvY2suIE5vdyB3ZSBy
ZXBseSBvbiBzaW5nbGUgaGN0eC0+cnVuX3dvcmsgZm9yIHRoYXQuCisgICAgICAgICovCisgICAg
ICAgaWYgKCFhc3luYyAmJiAhKGhjdHgtPmZsYWdzICYgKEJMS19NUV9GX0JMT0NLSU5HIHwKKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJMS19NUV9GX1NUUklDVF9ESVNQ
QVRDSF9PUkRFUikpKSB7CiAgICAgICAgICAgICAgICBpbnQgY3B1ID0gZ2V0X2NwdSgpOwogICAg
ICAgICAgICAgICAgaWYgKGNwdW1hc2tfdGVzdF9jcHUoY3B1LCBoY3R4LT5jcHVtYXNrKSkgewog
ICAgICAgICAgICAgICAgICAgICAgICBfX2Jsa19tcV9ydW5faHdfcXVldWUoaGN0eCk7CkBAIC0z
MDU1LDYgKzMwNjEsMTAgQEAgaW50IGJsa19tcV9hbGxvY190YWdfc2V0KHN0cnVjdCBibGtfbXFf
dGFnX3NldCAqc2V0KQogICAgICAgIGlmICghc2V0LT5vcHMtPmdldF9idWRnZXQgXiAhc2V0LT5v
cHMtPnB1dF9idWRnZXQpCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsKIAorICAgICAg
IGlmIChzZXQtPnF1ZXVlX2RlcHRoID4gMSAmJiAoc2V0LT5mbGFncyAmCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgQkxLX01RX0ZfU1RSSUNUX0RJU1BBVENIX09SREVSKSkKKyAgICAg
ICAgICAgICAgIHJldHVybiAtRUlOVkFMOworCiAgICAgICAgaWYgKHNldC0+cXVldWVfZGVwdGgg
PiBCTEtfTVFfTUFYX0RFUFRIKSB7CiAgICAgICAgICAgICAgICBwcl9pbmZvKCJibGstbXE6IHJl
ZHVjZWQgdGFnIGRlcHRoIHRvICV1XG4iLAogICAgICAgICAgICAgICAgICAgICAgICBCTEtfTVFf
TUFYX0RFUFRIKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGIvZHJpdmVy
cy9zY3NpL3Njc2lfbGliLmMKaW5kZXggOTFjMDA3ZDI2YzFlLi5mMDEzNjMwMjc1YzkgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2xp
Yi5jCkBAIC0xOTAyLDYgKzE5MDIsOSBAQCBpbnQgc2NzaV9tcV9zZXR1cF90YWdzKHN0cnVjdCBT
Y3NpX0hvc3QgKnNob3N0KQogICAgICAgIHNob3N0LT50YWdfc2V0LmZsYWdzID0gQkxLX01RX0Zf
U0hPVUxEX01FUkdFOwogICAgICAgIHNob3N0LT50YWdfc2V0LmZsYWdzIHw9CiAgICAgICAgICAg
ICAgICBCTEtfQUxMT0NfUE9MSUNZX1RPX01RX0ZMQUcoc2hvc3QtPmhvc3R0LT50YWdfYWxsb2Nf
cG9saWN5KTsKKyAgICAgICBpZiAoc2hvc3QtPmhvc3R0LT5zdHJpY3RfZGlzcGF0Y2hfb3JkZXIp
CisgICAgICAgICAgICAgICBzaG9zdC0+dGFnX3NldC5mbGFncyB8PSBCTEtfTVFfRl9TVFJJQ1Rf
RElTUEFUQ0hfT1JERVI7CisKICAgICAgICBzaG9zdC0+dGFnX3NldC5kcml2ZXJfZGF0YSA9IHNo
b3N0OwogCiAgICAgICAgcmV0dXJuIGJsa19tcV9hbGxvY190YWdfc2V0KCZzaG9zdC0+dGFnX3Nl
dCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3Njc2lnbHVlLmMgYi9kcml2ZXJz
L3VzYi9zdG9yYWdlL3Njc2lnbHVlLmMKaW5kZXggNTRhM2M4MTk1Yzk2Li5kZjE2NzRkN2YwZmMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2NzaWdsdWUuYworKysgYi9kcml2ZXJz
L3VzYi9zdG9yYWdlL3Njc2lnbHVlLmMKQEAgLTY1MSw2ICs2NTEsMTggQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgdXNiX3N0b3JfaG9zdF90ZW1wbGF0ZSA9IHsKICAg
ICAgICAvKiB3ZSBkbyBvdXIgb3duIGRlbGF5IGFmdGVyIGEgZGV2aWNlIG9yIGJ1cyByZXNldCAq
LwogICAgICAgIC5za2lwX3NldHRsZV9kZWxheSA9ICAgICAgICAgICAgMSwKIAorCisgICAgICAg
LyoKKyAgICAgICAgKiBTb21lIFVTQiBzdG9yYWdlLCBzdWNoIGFzIEtpbmdzdG9uIFRlY2hub2xv
Z3kgRGF0YVRyYXZlbGVyIDEwMAorICAgICAgICAqIEczL0c0L1NFOSBHMihJRCAwOTUxOjE2NjYp
LCByZXF1aXJlcyBJTyBkaXNwYXRjaGVkIGluIHRoZQorICAgICAgICAqIHNlcXVlbnRpYWwgb3Jk
ZXIsIG90aGVyd2lzZSBJTyBwZXJmb3JtYW5jZSBtYXkgZHJvcCBkcmFzdGljYWxseS4KKyAgICAg
ICAgKgorICAgICAgICAqIGNhbl9xdWV1ZSBpcyBhbHdheXMgMSwgc28gd2Ugc2V0IC5zdHJpY3Rf
ZGlzcGF0Y2hfb3JkZXIgZm9yCisgICAgICAgICogVVNCIG1hc3Mgc3RvcmFnZSBIQkEuIEFub3Ro
ZXIgcmVhc29uIGlzIHRoYXQgdGhlcmUgY2FuIGJlIHN1Y2gKKyAgICAgICAgKiBraW5kIG9mIGRl
dmljZXMgdG9vLgorICAgICAgICAqLworICAgICAgIC5zdHJpY3RfZGlzcGF0Y2hfb3JkZXIgPSAg
ICAgICAgMSwKKwogICAgICAgIC8qIHN5c2ZzIGRldmljZSBhdHRyaWJ1dGVzICovCiAgICAgICAg
LnNkZXZfYXR0cnMgPSAgICAgICAgICAgICAgICAgICBzeXNmc19kZXZpY2VfYXR0cl9saXN0LAog
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsay1tcS5oIGIvaW5jbHVkZS9saW51eC9ibGst
bXEuaAppbmRleCAwYmYwNTZkZTVjYzMuLjg5YjFjMjhkYTM2YSAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS9saW51eC9ibGstbXEuaAorKysgYi9pbmNsdWRlL2xpbnV4L2Jsay1tcS5oCkBAIC0yMjYsNiAr
MjI2LDcgQEAgc3RydWN0IGJsa19tcV9vcHMgewogZW51bSB7CiAgICAgICAgQkxLX01RX0ZfU0hP
VUxEX01FUkdFICAgPSAxIDw8IDAsCiAgICAgICAgQkxLX01RX0ZfVEFHX1NIQVJFRCAgICAgPSAx
IDw8IDEsCisgICAgICAgQkxLX01RX0ZfU1RSSUNUX0RJU1BBVENIX09SREVSICA9IDEgPDwgMiwK
ICAgICAgICBCTEtfTVFfRl9CTE9DS0lORyAgICAgICA9IDEgPDwgNSwKICAgICAgICBCTEtfTVFf
Rl9OT19TQ0hFRCAgICAgICA9IDEgPDwgNiwKICAgICAgICBCTEtfTVFfRl9BTExPQ19QT0xJQ1lf
U1RBUlRfQklUID0gOCwKZGlmZiAtLWdpdCBhL2luY2x1ZGUvc2NzaS9zY3NpX2hvc3QuaCBiL2lu
Y2x1ZGUvc2NzaS9zY3NpX2hvc3QuaAppbmRleCAzMWUwZDZjYTFlYmEuLmRiY2JjOWVmNjk5MyAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oCisrKyBiL2luY2x1ZGUvc2NzaS9z
Y3NpX2hvc3QuaApAQCAtNDQyLDYgKzQ0MiwxMyBAQCBzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRl
IHsKICAgICAgICAvKiBUcnVlIGlmIHRoZSBsb3ctbGV2ZWwgZHJpdmVyIHN1cHBvcnRzIGJsay1t
cSBvbmx5ICovCiAgICAgICAgdW5zaWduZWQgZm9yY2VfYmxrX21xOjE7CiAKKyAgICAgICAvKgor
ICAgICAgICAqIFRydWUgaWYgdGhlIGxvdy1sZXZlbCBkcml2ZXIgbmVlZHMgSU8gdG8gYmUgZGlz
cGF0Y2hlZCBpbgorICAgICAgICAqIHRoZSBvcmRlciBwcm92aWRlZCBieSBsZWdhY3kgSU8gcGF0
aC4gVGhlIGZsYWcgaXMgb25seQorICAgICAgICAqIHZhbGlkIGZvciBzaW5nbGUgcXVldWUgZGV2
aWNlLgorICAgICAgICAqLworICAgICAgIHVuc2lnbmVkIHN0cmljdF9kaXNwYXRjaF9vcmRlcjox
OworCiAgICAgICAgLyoKICAgICAgICAgKiBDb3VudGRvd24gZm9yIGhvc3QgYmxvY2tpbmcgd2l0
aCBubyBjb21tYW5kcyBvdXRzdGFuZGluZy4KICAgICAgICAgKi8KCg==


--=-YOcvGz7g6+q9SlGm1fMm--

