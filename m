From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 18/26] target/iscsi: Allocate session IDs from an IDA
Date: Thu, 26 Jul 2018 11:48:22 -0500
Message-ID: <5B59FB56.9090901@redhat.com>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-19-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621212835.5636-19-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Denys Vlasenko <dvlasenk@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/21/2018 04:28 PM, Matthew Wilcox wrote:

> @@ -1163,11 +1157,9 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
>  		goto old_sess_out;
>  	if (conn->sess->se_sess)
>  		transport_free_session(conn->sess->se_sess);
> -	if (conn->sess->session_index != 0) {
> -		spin_lock_bh(&sess_idr_lock);
> -		idr_remove(&sess_idr, conn->sess->session_index);
> -		spin_unlock_bh(&sess_idr_lock);

This code looks buggy. We will probably NULL pointer oops before we hit it.

It looks like the session_index check was supposed to detect when login
fails in the middle of doing login, so that code probably wanted to do:

idr_alloc(&sess_idr, NULL, 1, 0, GFP_NOWAIT);

The problem is that iscsi_login_zero_tsih_s1 sets conn->sess early in
iscsi_login_set_conn_values. If the function fails later like when we
alloc the idr it does kfree(sess) and leaves the conn->sess pointer set.
iscsi_login_zero_tsih_s1 then returns -Exyz and we then call
iscsi_target_login_sess_out and access the freed memory above.

So I am not sure what we want to do here for your patch since it is not
adding any new bugs. Just merge your patch now and I can send a fix for
the above bug over it?


> -	}
> +	/* Um, 0 is a valid ID.  I suppose we never free it? */
> +	if (conn->sess->session_index != 0)
> +		ida_free(&sess_ida, conn->sess->session_index);
>  	kfree(conn->sess->sess_ops);
>  	kfree(conn->sess);
>  	conn->sess = NULL;
> 
