From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2/5] - fusion - target reset when drive is being removed
Date: Thu, 26 Jan 2006 09:39:59 -0500
Message-ID: <43D8DF3F.6090206@emulex.com>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED50@NAMAIL2.ad.lsil.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53728 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751002AbWAZOkn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 09:40:43 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED50@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, James.Bottomley@SteelEye.com, hch@infradead.org

Interesting that you took this path.  I'm working on something similar
for the FC transport. When we finally decide the device is gone, we
want to kill the outstanding i/o. First thought in my mind was to use
a TMF - but this implies that you can contact the device to do the TMF.
Are you sending this before the device has actually gone away ?  If it's
after, I assume this then is a firmware function that handles things
accordingly at the link layer (e.g. may not send the TMF, will internally
abort the outstanding io's, may note the TR request and do it when the
device is later detected.... and so on).

Can you comment ?

-- james

Moore, Eric wrote:
> The issuing of the target reset 
> used in device hot removal case so the
> firmware queue is flushed out off outstanding
> commands.
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
