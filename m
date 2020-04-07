Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E9AC2BB55
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 15:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE882078C
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 15:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UNqco5YJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgDGPzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:55:10 -0400
Received: from mout.gmx.net ([212.227.15.18]:41155 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbgDGPzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 11:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586274896;
        bh=Y8CqZtz4ZQRui/81eNNZ4TzaarQvXmyN232y605+P9A=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=UNqco5YJjj80TjB5wUg4dOMO5e6ss+DUzeQ1yF4sPyNVmplnmXKjH0t7GuSpYPN3C
         46A0o/EI1wxDODDHE+BbWw19OPPsihMwQG53wdtnTBHS4WIj+Tqo6F2P8CbpMKKC5+
         PcOxQCa35fG7Ir+1roGUm7N5biraogjz61DTJOQQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from lenovo-laptop ([82.19.195.159]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M2O2W-1jJ6jh3gZ4-003xIe; Tue, 07
 Apr 2020 17:54:56 +0200
Date:   Tue, 7 Apr 2020 16:54:53 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Qiujun Huang <hqjagain@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: Remove null pointer checks before kfree()
Message-ID: <20200407155453.sosj4brsw6r7fnot@lenovo-laptop>
References: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
X-Provags-ID: V03:K1:DRRYbwkGmYsREHIOQQ6uPlqCNtM02NmcNjBlpaZ90sJF1rM80yD
 e6ihZf4UqFhDcC/0GKnGcIGdGicWIbcwH50hoPPm68oO/1GIkkY8/wL6swu9SaoQHlsP6gd
 VsgZ6OaQUaVOWzKlt1b5GzLN8gyd4EbO8/stVkQkAIe0NM8a/YnchitewJpWmVSMYt6+FUz
 g6WBqlo1KbyQPLwKvrEuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3n0zuGOgyNY=:CeZhKBZNkmIH8o8ERdVx8w
 yAJNkOcj0WwBjV5YyMFrzIxnlBd1PUx0nKGN9mjQH9+ZLTCmd/DIK/RMNCm080Qc60iU45TMo
 7A/YH6OYNTxIhvPjE3QNdWji1ogSiGnR6FkkOhzNOnXRpERIGLCLYDdhRcZQG9YxP4GO4tu/q
 Fg/MDID8Ea16ZOsd1tynnFJDZsyDMUoWwwqWw1QQLct3YHleAkM0oRgm/+17gCaJyc9ZSH+d6
 je6u0z7Q54AH/kKvgMYwk4ycLTOn5NgmGIiCZoI6AIYSPMTQGsS9Nyfl6Nz8zbnukWK5mtLTA
 bj8fqyn2M6lQEurtMFvczN454ditDio9rvbIMv1GO1eH14nMsgTIPwKUUN8l4+se8JPwVBqV2
 xeZul3eEh7YI0VTfFfqCfQYv3dTqPOvbxzTNkCnUm1T30ZQAxAB99EwNxEWRGzEhfda4p6e0k
 9F4vVjY2goQNmcOLRb0oXWEXegudfQtYU+0kKSOVRJyxCKLUiVZENmtpC//HxqK7n4VhVBHI1
 TqW4KK44FltpBa+CtWee/q08s7/G8bwvAC7u5+qtchjAt7xZtYDzjakneeQNpGyYSTIcLj5WZ
 5BBoAh7ErtUgOXHmMvPK8e5W3jTOQl6wx67zBjz1h/wlWym81vtHYAnMrZB7q3UR8ohYa/+bE
 j5MqL3QYgH8r+dbjTYIyXFqdM8AxpLn+5kWR/uO957zxI2Hvss0XN1wRsfGuFAL1bKU0JPmVb
 zPCDS8cOY42japw/qLEnVW6d2vR5v0Eyju5sdcN8F0wdI1VthlZE2OaosZPEdnjG/SvSxstll
 6bGhk0vpAFyuxhPIknln6SAqOs8BxjZRbt4wl5WE5I3SIqpCiEJJRGZRzu1B184z9tBZ9aVRK
 M0wSbBM3R938190r+zeahYBrw5VbZ9+EunLEEYWPigsT3mpnJhH62FKbd170CdNvFkZRPmP9a
 YW+GUdc+VEXczdusxzvuEOmZNo/AUrbQDwUbU6sJ9jM70VHKPerhs7Jt6vhJKmcNiihZ2dE0K
 ZFY8QMMqRqBl3izHcVsX4WBnXp9RkmTO3TpjRJ1ImNOD9SD7yvI9QA0ZBKyTYsJpT2PMO3ctQ
 WAMb0o8aUGHdHK6U4g88cXMPpg/DoNoLGcY8bSBPUlFcWXSiQght345P98gW2clhiDzZdycTM
 AdUpLwupL08mJdFrczskJmOlg2VwyX2ghQJtjY3+PX0KeSiQER5lUKF+tO8hkSzmDEDKdPxz0
 21NGO6xZJUEDN3NOP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Markus,

On Sun, Apr 05, 2020 at 10:02:47PM +0200, Markus Elfring wrote:
> > NULL check before kfree is unnecessary so remove it.
>
> I hope that you would like to take another update suggestion into accoun=
t
> (besides a typo correction for your commit message).
> https://lore.kernel.org/patchwork/patch/1220189/
> https://lore.kernel.org/linux-scsi/20200403164712.49579-1-alex.dewar@gmx=
.co.uk/

I'm not sure I understand the relevance. Are you saying I should
reference this other patch?

>
> Do you find a previous update suggestion like =E2=80=9CSCSI-aic7...: Del=
ete unnecessary
> checks before the function call "kfree"=E2=80=9D also interesting?
> https://lore.kernel.org/linux-scsi/54D3E057.9030600@users.sourceforge.ne=
t/
> https://lore.kernel.org/patchwork/patch/540593/
> https://lkml.org/lkml/2015/2/5/650
>

Thanks for the reference. I'll mention it in the commit if I do a v2.

Best,
Alex

> Regards,
> Markus
