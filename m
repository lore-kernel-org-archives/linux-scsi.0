From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] target: Allocate se_dev_entrys in device list only
 when used
Date: Fri, 7 Mar 2014 02:33:43 -0800
Message-ID: <20140307103343.GA14195@infradead.org>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com>
 <1394144131-31499-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394144131-31499-2-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>  static int core_create_device_list_for_node(struct se_node_acl *nacl)
>  {
> -	struct se_dev_entry *deve;
> -	int i;
> -
> -	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
> -			sizeof(struct se_dev_entry), GFP_KERNEL);
> +	nacl->device_list = kzalloc(TRANSPORT_MAX_LUNS_PER_TPG * sizeof(void*),
> +				    GFP_KERNEL);

Seems like ->device_list should simply be an array instead of a pointer.
