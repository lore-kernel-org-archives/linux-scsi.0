From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 04/16] iscsi-target: add void (*iscsit_release_cmd)()
Date: Sun, 10 Apr 2016 20:42:44 +0300
Message-ID: <570A9094.6010502@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <1499510260d6358522b4023822022f0add88b687.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499510260d6358522b4023822022f0add88b687.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org


> Add void (*iscsit_release_cmd)() to
> struct iscsit_transport, iscsi-target
> uses this callback to release transport
> driver resources associated with an iSCSI cmd.

I'd really like to see some reasoning on why you add
abstraction callouts. It may have a valid reason but
it needs to be documented in the change log...

> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 428b0d9..a533017 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -725,6 +725,9 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool scsi_cmd,
>   		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
>   		iscsit_remove_cmd_from_response_queue(cmd, conn);
>   	}
> +
> +	if (conn && conn->conn_transport->iscsit_release_cmd)
> +		conn->conn_transport->iscsit_release_cmd(conn, cmd);
>   }

Did you verify that you get here with conn = NULL (given that you test
it)? If so, then can you please document why is it expected for this
function to be called twice that we need to make it safe?

If not, then I'd move this check to be a WARN_ON/BUG_ON to hunt
down when is this happening.
