From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Fusion-MPT much faster as module - ifdef MODULE considered harmful
Date: Tue, 22 Mar 2005 11:36:35 -0800
Message-ID: <OF1B4228CB.88311E5C-ON88256FCC.00696D64-88256FCC.006B947E@us.ibm.com>
References: <20050322122801.GI3982@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50905 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261733AbVCVTgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 14:36:39 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j2MJaYEO024490
	for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 14:36:34 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2MJaY27084626
	for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 14:36:34 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2MJaXoe002556
	for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 14:36:34 -0500
In-Reply-To: <20050322122801.GI3982@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>, "Moore, Eric Dean" <emoore@lsil.com>, 'Holger Kiehl' <Holger.Kiehl@dwd.de>, "Chen, Kenneth W" <kenneth.w.chen@intel.com>, linux-scsi@vger.kernel.org

>  #if defined(CONFIG_FOO) || (defined(MODULE) && 
defined(CONFIG_FOO_MODULE))
>
>is a good way to express that driver bar can use functionality of driver 
>foo if it's available.

We need a way for a module to dynamically link itself, to whatever other 
modules it wants to use, and to be able to do that conditionally based on 
whether those other modules are loaded at the time it wants to use them.

Then we would not only get rid of one of the remaining distinctions 
between binding a module into the base kernel and loading it dynamically, 
but also this possibly last excuse for defined(MODULE).

As far as I know, we still don't have any kind of a generic registration 
service like this in the kernel.  I've had to resort to faking ioctls and 
proc file reads inside the kernel in order to get an address from another 
dynamically loaded module.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems

