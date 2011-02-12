From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: Question about transport_generic_allocate_tasks()
Date: Sat, 12 Feb 2011 12:10:27 -0800
Message-ID: <1297541427.13306.48.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=HhpMKKW6J7R5GR2yQ_V=222TeR1KKRpUp-Z0V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43096 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1BLUQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Feb 2011 15:16:58 -0500
In-Reply-To: <AANLkTi=HhpMKKW6J7R5GR2yQ_V=222TeR1KKRpUp-Z0V@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2011-02-12 at 15:33 +0100, Fubo Chen wrote:
> Target drivers assume that transport_generic_allocate_tasks() returns
> 0, -1 or -2. But if transport_generic_allocate_tasks() invoks
> transport_generic_cmd_sequencer() and if
> transport_generic_cmd_sequencer() invokes core_alua_state_check() the
> value 1 can be returned. Which is correct - drivers or core ? And what
> is meaning of return values ?
> 

Hi Fubo,

Note that when 'ret = T10_ALUA(su_dev)->alua_state_check(...)' is non
zero, there are two possible cases:

*) transport_generic_cmd_sequencer() will still 'return -2' when the
   (ret > 0) check is true from ->alua_state_check(...)

*) Or jump to the label out_invalid_cdb_field: that also will
   'return -2'.

So AFAICT transport_generic_cmd_sequencer() will never actually
'return ret' when 'ret = 1';

--nab

