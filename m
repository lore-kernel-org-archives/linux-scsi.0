From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 02/14] qla2xxx: Allow relogin to proceed if remote
 login did not finish
Date: Wed, 8 Feb 2017 18:42:20 +0000
Message-ID: <1486579326.16026.12.camel@sandisk.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486161655-2307-3-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <04ED866440044E46A1B8B42A5B42FD18@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> +	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
> +		unsigned long t = fcport->plogi_nack_done_jiff + HZ;
> +
> +		if (time_before_eq(jiffies, t))
> +			return;
> +	}

The above code occurs two times in this patch. We try to avoid duplicating
code in the Linux kernel, especially code that contains hardcoded constants.
Have you considered to change the name of plogi_nack_done_jiff into e.g.
plogi_done_deadline and to assign jiffies + HZ to that variable instead of
jiffies?

Bart.