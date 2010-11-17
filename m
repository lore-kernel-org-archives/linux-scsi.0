From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] fix kzalloc in scsi device handler
Date: Wed, 17 Nov 2010 12:04:04 +0200
Message-ID: <4CE3A894.5050303@panasas.com>
References: <AANLkTimsOGcybKBvJCjbtUaUpg5asYMDSky2QhovjcG+@mail.gmail.com> <E463DF2B2E584B4A82673F53D62C2EF4F51A7EDA@cosmail01.lsi.com> <201011161835.49079.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:59726 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab0KQKEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 05:04:07 -0500
In-Reply-To: <201011161835.49079.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, Hillf Danton <dhillf@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

On 11/16/2010 07:35 PM, Rolf Eike Beer wrote:
> 
> How about:
> 	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data) + sizeof(*h), GFP_KERNEL)?
> 
> Eike

I always prefer this form because this way I have all the information in
that single statement. I'm allocating space for scsi_dh_data for what ever
that would be. The other form I have to go looking up to see what is
scsi_dh_data's type and there is place for error.

Naturally for above it would follow:
	h = typeof(h)(scsi_dh_data + 1);

My $0.017
Boaz
