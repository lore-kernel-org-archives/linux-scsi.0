From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFCv3 10/21] tcm: Add SPC-4 compliant Persistent Reservations
	(PR)
Date: Mon, 08 Nov 2010 13:27:13 -0800
Message-ID: <1289251633.27226.66.camel@haakon2.linux-iscsi.org>
References: <1287441467-19915-1-git-send-email-nab@linux-iscsi.org>
	 <20101108145054.GA1295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108145054.GA1295@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 09:50 -0500, Christoph Hellwig wrote:
> Gcc on 32-bit x86 doesn't seem too happy about the stack usage here:
> 
> drivers/target/target_core_pr.c: In function '__core_scsi3_update_aptpl_buf':
> drivers/target/target_core_pr.c:1955: warning: the frame size of 1116 bytes is larger than 1024 bytes
> 

Hmmm, strange.  I am not seeing this on any of my 32-bit builds..  

Anyways, since __core_scsi3_update_aptpl_buf() is internally holding the
T10_RES(su_dev)->registration_lock while walking
T10_RES(su_dev)->registration_list to build the passed APTPL *buf, this
local scope tmp[1024] can be safetly converted to a
T10_RES(su_dev)->tmp_buf[] and drop the extra stack usage.

Thanks,

--nab

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
