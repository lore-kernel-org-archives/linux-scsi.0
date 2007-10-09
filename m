From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Date: Tue, 9 Oct 2007 09:41:47 -0700
Message-ID: <20071009164147.GB19854@plap3.qlogic.org>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org> <470B9E50.2090205@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22832 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXJIQlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 12:41:49 -0400
Content-Disposition: inline
In-Reply-To: <470B9E50.2090205@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

On Tue, 09 Oct 2007, James Smart wrote:

>  Why do you prefer request_firmware() vs something over sysfs ?
> 
>  Does environments like the kdump kernel also have access to data needed
>  by request_firmware() ?

There's already much in the way of automation and infrastructure
present in supporting the request_firwmare() interfaces (perhaps not
the best of names) which can provide for a level of flexibility beyond
a basic 'soft_port_name' interface.

Though I don't see why both can't coexist cleanly -- I take it the use
case you are considering is: software recognizes no valid WWPN
available, query via request_firmware() fails, software halts
initialization (rather than fail), and awaits the admin to poke
'0x123456.. > /sys/.../fc_host/soft_port_name', causing a ping to the
driver and continuation of initialization with requested portname?
