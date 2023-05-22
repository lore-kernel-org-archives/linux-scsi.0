Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0061C77B7C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 01:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjEVB7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 May 2023 21:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEVB7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2023 21:59:06 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1693AD2
        for <linux-scsi@vger.kernel.org>; Sun, 21 May 2023 18:59:04 -0700 (PDT)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230522015900epoutp04b7a026fcb82f6ec69df68fc0ae61ef67~hVJZp1ZTb2809428094epoutp04D
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 01:59:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230522015900epoutp04b7a026fcb82f6ec69df68fc0ae61ef67~hVJZp1ZTb2809428094epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684720740;
        bh=ztUQvKOuvNmzqdzLv07WGga892joPaAV/ihaahVqIMU=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Mdz8o5bj4DuoYiXe0871XMMR8EATu1Wj9CcoCPaApJLMU6wdjN7cg6HRo9DD2sgHG
         58uOqN0CVayI0Ga+zsO+3wWSJ0RelFoD+a9oOI06niV/im4WcVIjbr3mkmjtDKJcG1
         iVhyg3ys3jdomqjaT/xZ9PpuYe3ARlXjd6s/FhrE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230522015858epcas2p288aca94a3e9caa1f8eca38e9eb0cc78a~hVJXwWC0t2994929949epcas2p2b;
        Mon, 22 May 2023 01:58:58 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.99]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4QPgbj5vr8z4x9Px; Mon, 22 May
        2023 01:58:57 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.E6.11450.16CCA646; Mon, 22 May 2023 10:58:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20230522015856epcas2p283ba1242aebbaa298ae4b49201903838~hVJVq_FHE2710227102epcas2p2p;
        Mon, 22 May 2023 01:58:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230522015856epsmtrp2a1e2734e79508b848547ca15a309fc2b~hVJVqSsjM1254812548epsmtrp2B;
        Mon, 22 May 2023 01:58:56 +0000 (GMT)
X-AuditID: b6c32a45-1dbff70000022cba-61-646acc616575
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.A3.27706.06CCA646; Mon, 22 May 2023 10:58:56 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230522015856epsmtip2b559c06c35f8f94af20bb7b80b138784~hVJVfdwIx1826918269epsmtip27;
        Mon, 22 May 2023 01:58:56 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>, <junwoo80.lee@samsung.com>
In-Reply-To: <d6f2d05f-5dc2-3239-e4e6-299397a61ca0@acm.org>
Subject: RE: [PATCH v3] ufs: poll pmc until another pa request is completed
Date:   Mon, 22 May 2023 10:58:56 +0900
Message-ID: <000d01d98c50$f7826310$e6872930$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJgC3t4GWjRGEZyTuYf3rD9z4UL+gKD+kL6Aze8rwGuKqYWUA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZdljTTDfxTFaKwdqprBbTPvxktli9+AGL
        xa6/zUwWW2/sZLHovr6DzaLr7g1Gi6X/3rI4sHtcvuLt0bdlFaPH501yAcxR2TYZqYkpqUUK
        qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
        +nY2RfmlJakKGfnFJbZKqQUpOQXmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZezr+Mxc85aro
        OPmLtYHxEkcXIyeHhICJxNT5v5m7GLk4hAR2MEqcPLCaDcL5xCjx4v4xKOcbo8SzlXPYYVp+
        zfgE1bKXUeLEgiuMEM5LRolrD9eDVbEJaEtMe7ibFSQhInCWUeLcmlZWkASngLXE94fvWUBs
        YQFviROrtrGB2CwCqhLdCw6CxXkFLCWmbdjMDGELSpyc+QQszgw0dNnC18wQZyhI/Hy6DGym
        iICTxMx5q9ghakQkZne2gZ0nIfCVXeJH0wVWiAYXidPds1ggbGGJV8e3QP0jJfH53V6gIziA
        7GyJPQvFIMIVEounvYUqN5aY9aydEaSEWUBTYv0ufYhqZYkjt6Au45PoOPyXHSLMK9HRJgTR
        qCzxa9JkRghbUmLmzTtQOz0klnV0sE5gVJyF5MdZSH6cheSXWQh7FzCyrGIUSy0ozk1PLTYq
        MIRHdnJ+7iZGcLLUct3BOPntB71DjEwcjIcYJTiYlUR4A/uSU4R4UxIrq1KL8uOLSnNSiw8x
        mgJDfSKzlGhyPjBd55XEG5pYGpiYmRmaG5kamCuJ80rbnkwWEkhPLEnNTk0tSC2C6WPi4JRq
        YIo4UNN1eveT7JuH9phLX/vn96Jf9EC7o+RKgYhQJqMFMzlz0jmuc0xjffhZR1Xz33m9C8f0
        hGLua4mdCiz4VPHovIbZg5LjTEujQnc28Mn7GO78cqS+91uv3+z8jw9lDjFZ1G/flObuXi1W
        I3a8ho/l56NptRPbpxyRZ24wWS75h83mbVLqrlRjS6N2i1qjCivDhZmnxWb83aeucfjQy+2u
        a75Nyjp2ZOPszoXuE0xjEwodl4Rul7ugf42JOdHzxSWzqZ++Xdt+JoTz0WuG40d/3Ayt+Vqf
        9IqL+fZze8kn12TMgr9Pe936PnrFx8grsuv+n/+b31y4fS/rYiFOhgubnkUdWz73c6Xk9uyf
        M/4psRRnJBpqMRcVJwIAX5+Vex8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvG7CmawUgxltAhbTPvxktli9+AGL
        xa6/zUwWW2/sZLHovr6DzaLr7g1Gi6X/3rI4sHtcvuLt0bdlFaPH501yAcxRXDYpqTmZZalF
        +nYJXBn3F7xmLHjIVXH7aANLA+M5ji5GTg4JAROJXzM+MXcxcnEICexmlOjZuY4ZIiEpcWLn
        c0YIW1jifssRVoii54wSjzbdA0uwCWhLTHu4GywhInCVUeJJzyYmiKrjjBK3+2+yglRxClhL
        fH/4ngXEFhbwljixahsbiM0ioCrRveAgWJxXwFJi2obNzBC2oMTJmU/A4sxAG3oftjLC2MsW
        voY6T0Hi59NlYPNFBJwkZs5bxQ5RIyIxu7ONeQKj0Cwko2YhGTULyahZSFoWMLKsYpRMLSjO
        Tc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjhItzR2M21d90DvEyMTBeIhRgoNZSYQ3sC85RYg3
        JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamOffkm1SatrIw
        rjwkWm28Le5c2Xkpti6P/3dX3lbae6a7x+jLN66tU7LXVHyNW+V0z0hojYFZ2qR3599OfT91
        1eG7Hbf+O61dPj9Pv7/PZPvNL+7ht3m0fnc+PvDgxsmyWT+1xK0vLu26HKhcM3WHqdxShjes
        nLaWTSE94b+nnrJwLJi9//skpus8ZTwRcxftFJ7bfH/a004Vgc+O33UN3uQ1My5c+m3xxyda
        mg9so83f5eodO3HMb3H7xr9n+JRt9vQr/n4s+ZTXKZFHO/BsagbTox4e4Rj1q74CRXe1twof
        0moo61v+V+N/p/9hJ6EpOpnSPO2ncl6/Kvt/V8M/7vqRbdMWliWZ3tM0Dn4oqsRSnJFoqMVc
        VJwIAPKE5xcBAwAA
X-CMS-MailID: 20230522015856epcas2p283ba1242aebbaa298ae4b49201903838
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230516040117epcas2p4477bbc8aedf05a8c3bc0bd755eeadba0
References: <CGME20230516040117epcas2p4477bbc8aedf05a8c3bc0bd755eeadba0@epcas2p4.samsung.com>
        <1684209152-115304-1-git-send-email-kwmad.kim@samsung.com>
        <d6f2d05f-5dc2-3239-e4e6-299397a61ca0@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +		spin_lock_irqsave(hba->host->host_lock, flags);
> > +		hba->active_uic_cmd =3D NULL;
> > +		if (ufshcd_is_link_broken(hba)) =7B
> > +			spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +			ret =3D -ENOLINK;
> > +			goto out;
> > +		=7D
> > +		hba->uic_async_done =3D cnf;
> > +		cmd->argument2 =3D 0;
> > +		cmd->argument3 =3D mode;
> > +		ret =3D __ufshcd_send_uic_cmd(hba, cmd, true);
> > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> Please consider adding 	lockdep_assert_held(&hba->uic_cmd_mutex) near
> the start of __ufshcd_poll_uic_pwr() to document that this function is
> serialized against other contexts that submit an UIC.

Got it.

>=20
> Additionally, I don't think that it is necessary to hold the host lock
> around the ufshcd_is_link_broken() or __ufshcd_send_uic_cmd() calls.

I agree with you on __ufshcd_send_uic_cmd because of the mutex. And I wonde=
r why you make you think that on uic_link_state.
Is it because you think it's not possible to access uic_link_state simultan=
eously w/ the current code or it should be?

It seems most cases have no problems but anyway I think it seems that uic_l=
ink_state could be accessed from more than one context,
especially if auto hibern8 is enabled and only if some UIC errors occur.


Thanks.
Kiwoong Kim
>=20
> Thanks,
>=20
> Bart.
>=20


