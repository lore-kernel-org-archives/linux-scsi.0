Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A78C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 11:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiI3LHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 07:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiI3LHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 07:07:20 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D5BBD05B
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 03:43:33 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id j24so4363070lja.4
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 03:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=gJuXM+DJAzTKC+CIkd8GiPYoEUMeB41jf4e0UCepGAY=;
        b=P+7ZSwkV8vgsF6injBtkdbVrvAROv+QRDTB6esYcWWXbGatHN7HphOhZzcYNr0LaSM
         zmiF7s6gKa3x18CXK1zFGCG2fojoRjRk3ah3MpGE+Sztq09Ecyt9eUG4OvMavWiD9Jqd
         GjyT2Dwi+A13rEfExqSYdYG6+QEXlTa1A+ldYl3IzFO5HSlcNiQT1zs9D5QREmw+FjDM
         SVMXg7ttBOcoZovdGG5xs42KaEWtSCzv///H7QGlsDceiK7iKI1Oa0lrm8BXuXhULjs/
         nbpEjZIyJOTAw72EF8KRegGwI9IqJVE5e1cfZYuoNEvt6dcCE1z1h8wPXuGtzJoYm8dj
         mjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=gJuXM+DJAzTKC+CIkd8GiPYoEUMeB41jf4e0UCepGAY=;
        b=oIbHuTGpEPa4tGXUCiqO4RGK6Cm8YLhE/woTI+g82rAKmCk94DaJnzVW8nkdkNJh/n
         pe2+qZINho3oSXPxqo5ht46RhOMumJCuhpPt0GU1Fv+TY71uLhT+F2AYDgG5bGjxRM4h
         JM8SpoUyKv5C8cB9Up5aQBJtVYYjiNRpd8h/laDXb5e81qgC1RLtwtg4hfvtt5mxIyCa
         et+z1F2PRAsuAGzYfkGF+cTTyGuU/CPaIBwEjyjDE8RFb8o6SFqq9BuzrZJVG3q+Err3
         zUh8vwJdlWSkxKdsnLC/yJKHYW2LwvnZrnbr0hetunZPO8ezBQeCEyWXtckzUUZi9Czh
         Vm9A==
X-Gm-Message-State: ACrzQf1HNt/fE+7pBVFZuk+dVnQ/LRa3rn1dEZClqFhwrdT/WR0uim7y
        VZWVC2dvCu0QPJi0k0MjxZCqkzIXJQll0Q==
X-Google-Smtp-Source: AMsMyM7md++JsO7a3yDW0x6RPNzyG3ooK4bS9Y0IvYweT4WEeTYfVsaRDN9n6IfWNebrQ0s0n8e8fA==
X-Received: by 2002:a05:6402:1298:b0:457:c38a:2f10 with SMTP id w24-20020a056402129800b00457c38a2f10mr7647284edv.264.1664533723695;
        Fri, 30 Sep 2022 03:28:43 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id c9-20020a17090618a900b0077b2b0563f4sm971475ejf.173.2022.09.30.03.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 03:28:43 -0700 (PDT)
Message-ID: <c5ca12aea2cc0db29478c8cc68ef44851e07341f.camel@gmail.com>
Subject: Re: [PATCH v3 5/8] scsi: ufs: Use 'else' in
 ufshcd_set_dev_pwr_mode()
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Date:   Fri, 30 Sep 2022 12:28:42 +0200
In-Reply-To: <20220929220021.247097-6-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
         <20220929220021.247097-6-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-09-29 at 15:00 -0700, Bart Van Assche wrote:
> Convert if (ret) { ... } if (!ret) { ... } into
> if (ret) { ... } else { ... }.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
