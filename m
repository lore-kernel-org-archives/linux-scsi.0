From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ALUA support for scsi_debug
Date: Thu, 19 Oct 2006 10:50:30 -0400
Message-ID: <453790B6.9000802@torque.net>
References: <20061018145018.GC25084@pentland.suse.de> <45368C0B.7070802@torque.net> <45377943.8090906@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43730 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1946099AbWJSOtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 10:49:04 -0400
In-Reply-To: <45377943.8090906@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Hannes Reinecke wrote:
> Douglas Gilbert wrote:
>> Hannes,
>> Here is my counter patch for you to consider.
>> I suspect my machine was running into stack
>> problems so I moved some arrays onto the heap.
>>
> Ah. Good. To tell the truth I was a bit concerned once I've
> discovered that all information pages are infact statically allocated ...

I wasn't aware that statically allocated data (file or local
scope) would add to stack problems on a driver loaded as a
module. The arrays I moved to the heap were "auto" (i.e. non-static).

Most of the data scsi_debug keeps static are (manufacturer's)
default mode pages. They are constant. Keeping the current mode
page in static store is a bit more problematic: it may be
logically correct depending on the mode page policy (a VPD page)
but accesses probably should be locked if the page can be
modified (e.g. MRIE in the IEC mode page).


Over zealous error processing ....
I have made this mistake often enough, along with
many others, so hopefully some readers will take note:

<snip>
> +#define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
> +
> +static int resp_report_tgtpgs(struct scsi_cmnd * scp,
> +			      struct sdebug_dev_info * devip)
> +{
> +	unsigned char *cmd = (unsigned char *)scp->cmnd;
> +	unsigned char * arr;
> +	int host_no = devip->sdbg_host->shost->host_no;
> +	int n, ret, alloc_len, rlen;
> +	int target_dev_id, port_group_a, port_group_b, port_a, port_b;
> +
> +	alloc_len = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
> +		     + cmd[9]);
> +	if (alloc_len < 4 + (11 * 2)) {
> +		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
> +			       	0);
> +		return check_condition_result;
> +	}
> +	
> +	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_KERNEL);
> +	n = 4;
> +	/*
> +	 * Each host has it's own target port group.
> +	 * The asymmetric access state is cycled according to the host_id.
> +	 */
> +	target_dev_id = ((host_no + 1) * 2000) +
> +			(devip->target * 1000) - 3;
> +	port_a = target_dev_id + 1;
> +	port_b = target_dev_id + 2;
> +	port_group_a = (((host_no + 1) & 0x7f) << 8) + 
> +	    (devip->channel & 0xff);
> +	port_group_b = (((host_no + 1) & 0x7f) << 8) + 
> +	    (devip->channel & 0xff) + 0x80;
> +	if (0 == scsi_debug_vpd_use_hostno) {
> +	    arr[n++] = host_no % 3; /* Asymm access state */
> +	    arr[n++] = 0x0F; /* claim: all states are supported */
> +	} else {
> +	    arr[n++] = 0x0; /* Active/Optimized path */
> +	    arr[n++] = 0x01; /* claim: only support active/optimized paths */
> +	}
> +	arr[n++] = (port_group_a >> 8) & 0xff;
> +	arr[n++] = port_group_a & 0xff;
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = 0;    /* Status code */
> +	arr[n++] = 0;    /* Vendor unique */
> +	arr[n++] = 0x1;  /* One port per group */
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = (port_a >> 8) & 0xff;
> +	arr[n++] = port_a & 0xff;
> +	arr[n++] = 3;    /* Port unavailable */
> +	arr[n++] = 0x0F; /* claim: all states are supported */
> +	arr[n++] = (port_group_b >> 8) & 0xff;
> +	arr[n++] = port_group_b & 0xff;
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = 0;    /* Status code */
> +	arr[n++] = 0;    /* Vendor unique */
> +	arr[n++] = 0x1;  /* One port per group */
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = 0;    /* Reserved */
> +	arr[n++] = (port_b >> 8) & 0xff;
> +	arr[n++] = port_b & 0xff;
> +
> +	rlen = n - 4;
> +	arr[0] = (rlen >> 24) & 0xff;
> +	arr[1] = (rlen >> 16) & 0xff;
> +	arr[2] = (rlen >> 8) & 0xff;
> +	arr[3] = rlen & 0xff;
> +
> +	if (alloc_len < n) {
> +		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
> +			       	0);
> +		kfree(arr);
> +		return check_condition_result;
> +	}
> +	
> +	ret = fill_from_dev_buffer(scp, arr,
> +				   min(n, SDEBUG_MAX_TGTPGS_ARR_SZ));
> +	kfree(arr);
> +	return ret;
> +}
<snip>

The above code is building a response to the REPORT TARGET
PORT GROUPS command. The first 4 bytes of the response are
the length of the response irrespective of whether the response
is truncated by alloc_len (a field in the RTPG command).
It is _not_ an error if alloc_len < n (see spc4r07a.pdf section
4.3.4.6). This allows the application client to ask for a 4
byte response if it is worried about how big the response
will be, then issue the command again with an appropriate
allocation length. This is a common paradigm with mode and
log pages.

So the "if (alloc_len < 4 + (11 * 2))" block should be
removed. Also the "if (alloc_len < n)" block should be
removed and "min" should be (possibly a cleaner version of):
  min(min(alloc_len, n), SDEBUG_MAX_TGTPGS_ARR_SZ))

Doug Gilbert
