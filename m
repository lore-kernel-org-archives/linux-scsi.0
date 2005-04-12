From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptscsih: MODULE_PARM() -> module_param()
Date: Tue, 12 Apr 2005 11:38:19 -0500
Message-ID: <1113323900.5774.35.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01DBBC2C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3717 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262458AbVDLQif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 12:38:35 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C01DBBC2C@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Magnus Damm <damm@opensource.se>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mpt_linux_developer@lsil.com

On Tue, 2005-04-05 at 14:30 -0600, Moore, Eric Dean wrote:
> Ok fine - This fix is already there in the series of patches
> I provided a week ago for splitting the mpt fusion drivers
> into seperate bus type drivers.
> 
> James any word on whether those series of patches will get
> approved?

The patches themselves look fine.  However, there's a problem which I
just discovered on putting it together and taking it for a test spin:
the MODULE_DEVICE_TABLE directive is still in mptbase.  This means that
the udev/hotplug system thinks that when it's loaded mptbase
everything's done, which now means that everyone loses their devices
since the upper drivers aren't loaded.  To make this all work and keep
the distros happy, the MODULE_DEVICE_TABLE has to be split out and
placed into the mptspi or mptfc components.

James


