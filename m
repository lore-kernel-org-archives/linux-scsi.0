From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2] ibmvscsis: Do not send aborted task response
Date: Tue, 02 May 2017 20:43:26 -0700
Message-ID: <1493783006.23202.87.camel@haakon3.risingtidesystems.com>
References: <1493751261-81647-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1493751261-81647-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Bart.VanAssche@sandisk.com, martin.petersen@oracle.com, turtle.in.the.kernel@gmail.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-05-02 at 13:54 -0500, Bryant G. Ly wrote:
> The driver is sending a response to the actual scsi op that was
> aborted by an abort task TM, while LIO is sending a response to
> the abort task TM.
> 
> ibmvscsis_tgt does not send the response to the client until
> release_cmd time. The reason for this was because if we did it
> at queue_status time, then the client would be free to reuse the
> tag for that command, but we're still using the tag until the
> command is released at release_cmd time, so we chose to delay
> sending the response until then. That then caused this issue, because
> release_cmd is always called, even if queue_status is not.
> 
> SCSI spec says that the initiator that sends the abort task
> TM NEVER gets a response to the aborted op and with the current
> code it will send a response. Thus this fix will remove that response
> if the TAS bit is set.
> 
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 66 ++++++++++++++++++++++----------
>  1 file changed, 45 insertions(+), 21 deletions(-)

Applied, with a small update to the last sentence of the commit log wrt
to 'if ABORTED && !TAS bit is set'.

Thanks Bryant + Tyrel.
