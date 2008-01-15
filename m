From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPT Fusion initialization in 2.6.23.12
Date: Mon, 14 Jan 2008 18:19:30 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70C5D129@NAMAIL4.ad.lsil.com>
References: <da824cf30801141641u7baac682haa1ff06dddc5da99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58098 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYAOBTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 20:19:50 -0500
Content-class: urn:content-classes:message
In-Reply-To: <da824cf30801141641u7baac682haa1ff06dddc5da99@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>, Karen Shaeffer <shaeffer@neuralscape.com>
Cc: linux-scsi@vger.kernel.org

On  Monday, January 14, 2008 5:42 PM, Grant Grundler wrote:
> > mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page: 
> type=08h, page=00h, action=01h, form=00000001h
> 
> My interpretation of this (and Eric should know this alot better) is
> the host is attempting to
> read (action=01h) this page (type 08h ==
> MPI_CONFIG_PAGETYPE_RAID_VOLUME) and couldn't.
> ie maybe HW RAID isn't configured on the card?
> 

Grant - Your right that this is MPI_CONFIG_PAGETYPE_RAID_VOLUME(=0x8).
I responded too soon earlier, my thinking it was scanning the sas
topology, in which its expected to get Invalid pages.  In previous
email, the form being passed (1 thru 0xF) means someone is scaning the
target ids, from 1 thru 15.  I just checked my code, and there is no
place where I scan volumes. The only place I ask for the volume pages,
is in mpt_inactive_raid_volume, and I only ask for this page when I
already know the target_id.  Thus I think this must be application
driven thru mptctl interface.

Eric   
