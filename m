From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [janitor] (1/5) aic7xyz: use kernel.h min/max/ARRAY_SIZE
Date: Mon, 03 May 2004 13:48:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <608585408.1083613686@aslan.scsiguy.com>
References: <20040427110417.6a7c35ff.rddunlap@osdl.org>	 <596965408.1083611410@aslan.scsiguy.com>
 <1083612090.3843.8.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:12814 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S263932AbUECTs2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2004 15:48:28 -0400
In-Reply-To: <1083612090.3843.8.camel@laptop.fenrus.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>

>> With the exception of two files, this patch changes the driver core.
>> These files must compile on several different OSes and thus must not
>> become dependent on Linux specific macros.
> 
> since when is min() linux specific? Maybe your other OS has it too.. if
> so I doubt it'll have any other semantics than the linux one, and if it
> doesn't have it, it's like REALLY easy to just add one in the compat
> layer for that OS.

Actually, all of the other supported OSes call min(), MIN() since it is
a macro and typical C convention is to use all caps for macros.

Anyway... The core is not supposed to "look like Linux".  Its supposed to
be (and is) portable.  That's why it is implemented in terms of an API
exported by the OSM.  If the core has to be modified every-time Linux or
any other supported OSes changes the name of something, there isn't much
point in having a core layer to the driver.  The changes proposed here
will force 5 other OSM modules to change with *no* functional improvement
to the driver.

Since the kernel.org drivers aren't the latest, and the trend has been
toward ignoring the latest drivers and instead re-implementing the fixes
already there (e.g. the pci registration stuff), I'm not going to fight
you one way or the other.  I just thought it was important to explain
that these changes are an layering violation in the driver, not an
enhancement.

--
Justin

