Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F0EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 22:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjG1WuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjG1WuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 18:50:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30141173F;
        Fri, 28 Jul 2023 15:50:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690584616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6IqxueJihZdskvWxidXUVsjKtqOSCm2RR/PabSw5ug8=;
        b=IHMd2CQu+RUSScvlJTJWocAFi6CYMIjmSSvzxYR4SVUuNfEzsjoTNfmVk4BPk++YB3xMtw
        C2Hb9SZ7XxQzGyanFTP1XZwSjCNwzeV9m+49sY2CBz+BXFdhwV3ZK1yG9f+menpNAWKYj9
        wFBzqO2l9P2dDJPNMG1DVDgKGoPvNra1ft5XP8EWPJU95AU+FNEgNx9vnZuV/rhr2STbRW
        9i3R0sqatM563UDwYbkCJfOWlplTXoWkjM2ReakKhVPm3/VtL+jLx9FIq6Ph5A0GeZg09j
        Ly2zI06kxzDNpoAyErn+YNo3JpWqLPzRWIW7IcEbBnqceGlPl6WjATa8N9Nhdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690584616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6IqxueJihZdskvWxidXUVsjKtqOSCm2RR/PabSw5ug8=;
        b=YIU21vK5J7ASWrNM8Toawzal/abIIPXf8upc4Jld2Q3sjseBlomtk9m8MLINaebPXLKBDB
        fedYBRbOTvSEPjAA==
To:     Sohil Mehta <sohil.mehta@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Huang Rui <ray.huang@amd.com>, Juergen Gross <jgross@suse.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>
Subject: Re: [patch v2 11/38] x86/apic: Use BAD_APICID consistently;
In-Reply-To: <48b6d063-8528-2208-5117-5c9c095886e5@intel.com>
References: <20230728105650.565799744@linutronix.de>
 <20230728120930.281607646@linutronix.de>
 <48b6d063-8528-2208-5117-5c9c095886e5@intel.com>
Date:   Sat, 29 Jul 2023 00:50:16 +0200
Message-ID: <87wmyjps5z.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 28 2023 at 15:36, Sohil Mehta wrote:

> There is an extra semicolon at the end of the patch subject.

Oops

> On 7/28/2023 5:12 AM, Thomas Gleixner wrote:
>> APIC ID checks compare with BAD_APICID all over the place, but some
>> initializers and some code which fiddles with global data structure use
>> -1[U] instead. That simply cannot work at all.
>> 
>> Fix it up and use BAD_APICID consistenly all over the place.
>> 
>
> s/consistenly/consistently

Indeed.
