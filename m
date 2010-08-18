From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 1/1] Remove LUNs that no longer exist when we scan a
 target with REPORT LUNS.
Date: Wed, 18 Aug 2010 08:10:44 -0700
Message-ID: <AANLkTi=LvbUnQjPjFrHFtszMkY526mu8X9vCrMDEBO5C@mail.gmail.com>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
	<1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43076 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab0HRPKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 11:10:45 -0400
Received: by gwj17 with SMTP id 17so228084gwj.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2010 08:10:45 -0700 (PDT)
In-Reply-To: <1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Richard Sharpe <realrichardsharpe@gmail.com>

On Sun, Aug 15, 2010 at 5:08 PM,  <realrichardsharpe@gmail.com> wrote:
> From: Richard Sharpe <realrichardsharpe@gmail.com>
>
> If the target returns logical_unit_not_supported when we send REPORT LUNS
> it means that it supports REPORT LUNS but there really are no LUNs there.
> Delete LUN 0 in that case.
>
> Also, when parsing the LUNs reported, remove any LUNs that used to exist
> in the gaps, and remove LUNs beyond the end of those reported. They no
> longer exist.
>
> Also don't scan a target where the ID is too large or the channel is
> too large.
>
> Tested by adding four LUNs with scst_local and then deleting them in
> various combinations, including deleting from LUN 0, deleting from last
> LUN and deleting in the middle out.

Hmmm, before James responds, it turns out that I did not test as
carefully as I thought, and deleting LUNs in the order 0, 2, ... does
not produce the results I expected, so I will have to rework this.

-- 
Regards,
Richard Sharpe
