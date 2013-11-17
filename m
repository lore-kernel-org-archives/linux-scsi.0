From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor
 code
Date: Sun, 17 Nov 2013 11:42:51 -0800
Message-ID: <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54561 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab3KQTmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Nov 2013 14:42:55 -0500
In-Reply-To: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' when
> necessary.

You pointlessly renamed a variable, which makes the diff hard to read.
Please don't do that.

You missed the fact that the passed in pointer is unmodified if
mgmt_get_if_info() returns non zero, so the kfree frees junk and would
oops.

There's no need for a goto; len = -EINVAL; does everything that's
needed.

James


