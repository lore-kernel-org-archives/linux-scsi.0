From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 1 Dec 2003 19:22:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202032253.GA175030@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:29278 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S264292AbTLBDYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2003 22:24:00 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

Andrew,

The enable_64bit_addressing flag is set in qla2x00_nvram_config().
It is then later overridden in qla2x00_config_dma_addressing().

Since we would like to call qla2x00_config_dma_addressing() before
consistent allocations in order to set the consistent mask, that
would mean that the flag set in qla2x00_config_dma_addressing() would
now be overridden in qla2x00_nvram_config().

What was your intention here?  It seems to me that you should not
be touching this flag in qla2x00_nvram_config().  Is that correct?

Is there any other problem caused by moving the call to
qla2x00_config_dma_addressing() to an early position?

thanks

jeremy
