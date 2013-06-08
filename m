From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/9] target: Avoid extra t_state_lock access in
	__target_execute_cmd
Date: Sat, 8 Jun 2013 08:32:12 +0200
Message-ID: <20130608063212.GA27598@lst.de>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org> <1370640864-15568-5-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370640864-15568-5-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 07, 2013 at 09:34:19PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch makes target_execute_cmd() set CMD_T_BUSY|CMD_T_SENT while
> holding se_cmd->t_state_lock, in order to avoid the extra aquire/release
> in __target_execute_cmd().

Can you also do an audit that we actually still need all these flags?
I'm pretty sure there's a fair amount of duplication between all the t_state
and transport_state flags that could be rationalized.
